package memorphic.xpath.parser
{

	import memorphic.parser.Token;
	import memorphic.parser.TokenPattern;
	import memorphic.parser.Tokenizer;
	import memorphic.parser.ParseError;
	import memorphic.parser.TokenMetrics;
	import memorphic.xpath.XPathAxes;
	import memorphic.xpath.XPathNodeTypes;

	/**
	 * W3C XPath 1.0 Recommendation at http://www.w3.org/TR/xpath
	 *
	 * The Tokenizer is responsible for breaking up the rawData input stream into tokens and identifying
	 * their types. XPathSyntaxTree is responsible for defining the structure
	 */
	final public class XPathTokenizer extends Tokenizer
	{

		private var lastMatchType:String;

		// XML types
		// see:
		//	 - http://www.w3.org/TR/REC-xml
		//	 - http://www.w3.org/TR/REC-xml-names
		// TODO: NCName currently does not support unicode characters outside basic English

		private static const NCName:String = "[a-zA-Z_][a-zA-Z_\\d\\-]*";


		// XPath Types
		// (see http://www.w3.org/TR/xpath)



		/**
			[39] ExprWhitespace	::=
					S
		*/
		private static const ExprWhitespace:String = "\\s+";


		/**
			[38] NodeType ::=
					'comment'
					| 'text'
					| 'processing-instruction'
					| 'node'
		*/
		private static function isNodeType(value:String):Boolean
		{
			return XPathNodeTypes.isNodeType(value);
		}

		/**
			[37] NameTest ::=
					'*'
					| NCName ':' '*'
					| QName

			@see #createToken()
		*/


		/**
			[36] VariableReference ::=
					'$' QName

			VariableReference is now moved to grammar tree. Just detect the $ in the tokenizer.,

			@see #createToken()
		*/



		/**
			[35] FunctionName ::=
					QName - NodeType
		*/
		private static function isFunctionName(type:String, value:String):Boolean
		{
			return (type == XPathToken.NCNAME && !isNodeType(value));
		}


		/**
			[34] MultiplyOperator ::=
					'*'
		*/
		private static const MultiplyOperator:String = "\\*";

		/**
			[33] OperatorName ::=
					'and' | 'or' | 'mod' | 'div'
		*/
		private static const OperatorName:String = "and | or | mod | div";

		/**
			[32 Operator ::=
					OperatorName
					| MultiplyOperator
					| '/' | '//' | '|' | '+' | '-' | '=' | '!=' | '<' | '<=' | '>' | '>='

			Note: //,/ <, <= and >= are in size order, to ensure largest match (TODO: find out why this is necessary)
		*/
		private static const Operator:String = OperatorName + "|" + MultiplyOperator +
				"| \\/\\/ | \\/ | \\| | \\+ | - | = | \\!= | <= | >= | < | >";

		/**
			[31] Digits ::=
					[0-9]+
		*/
		private static const Digits:String = "\\d+";

		/**
			[30] Number	::=
					Digits ('.' Digits?)?
					| '.' Digits
		*/
		private static const Num:String = Digits + " (\\. " + Digits + "?)? | \\. " + Digits;

		/**
			[29] Literal ::=
					'"' [^"]* '"'
					| "'" [^']* "'"

			note: selecting groups could be added so that " or ' can be discarded. But, currently, the
			tokenizer does not support match results that are a different length from the actual source
			text that they matched
		*/
		private static const Literal:String = Literal + "\\\"[^\\\"]*\\\" | \\'[^\\']*\\'";


		/**
			[28] ExprToken ::=
				'(' | ')' | '[' | ']' | '.' | '..' | '@' | ',' | '::'
				| NodeType
				| NameTest
				| Operator
				| FunctionName
				| AxisName
				| Literal
				| Number
				| VariableReference

			Note: ".." comes before "." to ensure that biggest is matched.

		*/
		private static const ExprToken_misc:String = "\\$ | \\( | \\) | \\[ | \\] | \\.\\. | \\. | \\@ | \\, | \\:\\:";
		private function isExprToken(type:String):Boolean
		{
			switch (type){
			// ExprToken_misc is for the extra un-named values for ExprToken
			case XPathToken._EXPR_TOKEN_MISC:
			case XPathToken.NAME_TEST:
			case XPathToken.NODE_TYPE:
			case XPathToken.OPERATOR:
			case XPathToken.FUNCTION_NAME:
			case XPathToken.AXIS_NAME:
			case XPathToken.LITERAL:
			case XPathToken.NUMBER:
			case XPathToken.VARIABLE_REFERENCE:
				return true;
			default:
				return false;
			}
		}


		/**
			[6] AxisName	::=
		 			'ancestor'
		  			| 'ancestor-or-self'
		  			| 'attribute'
		  			| 'child'
		  			| 'descendant'
		  			| 'descendant-or-self'
		  			| 'following'
		  			| 'following-sibling'
		  			| 'namespace'
		  			| 'parent'
		  			| 'preceding'
		  			| 'preceding-sibling'
		  			| 'self'
		*/
		private static function isAxisName(value:String):Boolean
		{
			return XPathAxes.isAxisName(value);
		}


		public function XPathTokenizer(){
			// These are the basic patterns. More precise token types are identified in
			// createToken()
			// TODO: optimize order, and implement bailout flag
			addTokenPattern(new TokenPattern(XPathToken._EXPR_TOKEN_MISC, ExprToken_misc));
			addTokenPattern(new TokenPattern(XPathToken.LITERAL, Literal));
			addTokenPattern(new TokenPattern(XPathToken.NUMBER, Num));
			addTokenPattern(new TokenPattern(XPathToken.DIGITS, Digits));
			addTokenPattern(new TokenPattern(XPathToken.OPERATOR, Operator));
			addTokenPattern(new TokenPattern(XPathToken.NCNAME, NCName));
			addTokenPattern(new TokenPattern(XPathToken.EXPR_WHITESPACE, ExprWhitespace ));

		}





		private static function tokenMayPrecedeOperator(token:Token) : Boolean
		{
			switch (token.value){
			case "@": case "::": case "(": case "[": case ",":
				return false;
			default:
				if (token.tokenType == XPathToken.OPERATOR){
					return false;
				} else {
					return true;
				}
			}
		}

		/**
		 *
		 * [from spec] For readability, whitespace may be used in expressions even though not explicitly
		 *	allowed by the grammar: ExprWhitespace may be freely added within patterns before
		 *	or after any ExprToken.
		 *
		 *
		 * The following special tokenization rules must be applied in the order specified to
		 * disambiguate the ExprToken grammar:
		 * 		* If there is a preceding token and the preceding token is not one of @, ::,
		 *		      (, [, , or an Operator, then a * must be recognized as a MultiplyOperator and
		 *		      an NCName must be recognized as an OperatorName.
		 *		    * If the character following an NCName (possibly after intervening
		 *		      ExprWhitespace) is (, then the token must be recognized as a NodeType or a
		 *		      FunctionName.
		 *		    * If the two characters following an NCName (possibly after intervening
		 *		      ExprWhitespace) are ::, then the token must be recognized as an AxisName.
		 *		    * Otherwise, the token must not be recognized as a MultiplyOperator, an
		 *		      OperatorName, a NodeType, a FunctionName, or an AxisName.
		 *
		 */
		protected override function createToken(production:TokenPattern, value:String, sourceIndex:int, prev:Token=null):Token
		{
			var type:String = lastMatchType = production.name;

			/*
				// TODO: investigate if there is a problem with just ignoring all whitespace
				// (i.e. just returning null in this case)
			*/
			if (type == XPathToken.EXPR_WHITESPACE)
			{

				// FIXME: ATM whitespace is allowed everywhere. The code below is broken because
				// tokenPosition gets messed up if you discard the token after doing a look-ahead
				return skipToken(new XPathToken(XPathToken.EXPR_WHITESPACE, value, sourceIndex));
				//return null;
				/*
				var next:Token = lookAhead();
				if((prev == null || isExprToken(prev.tokenType))
					&& (next == null || isExprToken(next.tokenType)))
				{
					// discard the whitespace in this situation
					return skipToken();
				}else{
					trace("ERROR");
					var metrics:TokenMetrics = getTokenMetrics(prev);
					metrics.column += prev.length;
					throw new ParseError("Whitespace is not permitted here.", metrics);
				}
				/**/
			} else {

				if(type==XPathToken.NCNAME){
					return resolveNCName(value, sourceIndex);
				}
				else if (value == "*")
				{
					if(prev != null && tokenMayPrecedeOperator(prev)){
						return new XPathToken(XPathToken.MULTIPLY_OPERATOR, value, sourceIndex);
					}

				}else if(value == "$"){
					var next1:Token = lookAhead(1);
					if(next1 is QNameToken){
						next1.tokenType = XPathToken.VARIABLE_REFERENCE;
						skipAhead(1);
						return next1;
					}else{
						throw new SyntaxError();
					}
				}
			}

			return new XPathToken(type, value, sourceIndex);
		}




		private function resolveNCName(value:String, sourceIndex:int):Token
		{
			var prev:Token = this.token;
			var next1:Token = lookAhead(1);

			if(prev != null && tokenMayPrecedeOperator(prev)){
				return new XPathToken(XPathToken.OPERATOR_NAME, value, sourceIndex);
			}
			if(isAxisName(value)){
				return new XPathToken(XPathToken.AXIS_NAME, value, sourceIndex);
			}
			if(next1.value == "("){
				if(isNodeType(value)){
					return new XPathToken(XPathToken.NODE_TYPE, value, sourceIndex);
				}else{
					return new XPathToken(XPathToken.FUNCTION_NAME, value, sourceIndex);
				}

			}else if(next1.value == "::"){
				skipAhead(1);
				return new XPathToken(XPathToken.AXIS_NAME, value, sourceIndex);

			}else if(next1.value == ":"){
				var next2:Token = lookAhead(2);

				if(next2.value == "*" || next2.tokenType == XPathToken.NCNAME){
					skipAhead(2);
					return new QNameToken(XPathToken.NAME_TEST, value, next2.value, sourceIndex);
				}else{
					// XXX: should the namespace part be "" or "*" ??
					return new QNameToken(XPathToken.NAME_TEST, "", value, sourceIndex);
				}
			}else {
				return new QNameToken(XPathToken.NAME_TEST, "", value, sourceIndex);
			}
		}


	}



}

