package memorphic.xpath.parser
{
	import memorphic.parser.Token;

	public class XPathToken extends Token
	{
		
		// XML types
		// see:
		//	 - http://www.w3.org/TR/REC-xml
		//	 - http://www.w3.org/TR/REC-xml-names
		
		public static const NCNAME:String = "NCName";
		
		// QName is never explicitly created
		//public static var QNAME:String = "QName";
		// but we need the delimiter
		public static const _QNAME_DELIMITER:String = "_QName_delimiter";
		
		
		// XPath Types
		// (see http://www.w3.org/TR/xpath)

		// [6]
		public static const AXIS_NAME:String = "AxisName";
		
		// [28] 
		//public static const EXPR_TOKEN:String = "ExprToken";
		
		// [Not directly from spec]
		public static const _EXPR_TOKEN_MISC:String = "ExprToken_misc";

		// [29]
		public static const LITERAL:String = "Literal";

		// [30] 
		public static const NUMBER:String = "Number";

		// [31] 
		public static const DIGITS:String = "Digits";

		// [32] 
		public static const OPERATOR:String = "Operator";

		// [33]
		public static const OPERATOR_NAME:String = "OperatorName";
			
		// [34] 
		public static const MULTIPLY_OPERATOR:String = "MultiplyOperator";
		
		//	[35] 
		public static const FUNCTION_NAME:String = "FunctionName";
			
		// [36]  
		public static const VARIABLE_REFERENCE:String = "VariableReference";
			
		// [37] 
		public static const NAME_TEST:String = "NameTest";

		// [38]
		public static const NODE_TYPE:String = "NodeType";
	
		// [39]
		public static const EXPR_WHITESPACE:String = "ExprWhitespace";
		
		
		
		public function XPathToken(type:String, value:String, sourceIndex:int)
		{
			super(type, value, sourceIndex);
		}
	}
}