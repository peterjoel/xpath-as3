package memorphic.parser
{
	import flash.errors.EOFError;
	
	/**
	 *
	 * SyntaxTree is an abstract base class for Abstract Syntax Tree parsers.
	 *
	 * In general, create rules which are methods of the form:
	 * <pre>
	 * 		public function RuleName():Boolean
	 * 		{
	 * 			startRule("RuleName");
	 * 			//....
	 * 			nextToken();
	 * 			//....
	 * 			return match();
	 * 		}
	 * </pre>
	 *
	 * Invoke other rules, to determine if a match has been made.
	 * Rules must always invoke match() or didntMatch() before returning.
	 */
	public class SyntaxTree
	{

		protected var stack:Array;
		protected var lastMatchedToken:Token;
		protected var tokenizer:Tokenizer;
		protected var token:Token;


		/**
		 * override in subclasses to invoke the root rule before returning this
		 */
		public function getTree():SyntaxTreeItem
		{
			//verifyTree();
			return stack[0] as SyntaxTreeItem;
		}

		protected function verifyTree():void
		{
			if(stack.length > 1){
				throw new ParseError("Some parsing went awry",
					tokenizer.getTokenMetrics(firstUnmatchedToken()));
			}
			/*
			if(tokenizer.bytesAvailable() > 0){
				throw new ParseError("Some parsing went awry",
					tokenizer.getTokenMetrics(firstUnmatchedToken()));
			}*/
			var eof:Boolean = false;
			try {
				tokenizer.nextToken();
			}catch(e:EOFError){
				eof = true;
			}
			if(!eof){
				throw new ParseError("Some parsing went awry", null);
			}
		}


		public function SyntaxTree(tokenizer:Tokenizer){
			this.tokenizer = tokenizer;
			reset();
		}


		final public function reset():void
		{
			this.lastMatchedToken = new Token(null, null, 0);
			this.tokenizer.reset();
			this.token = null;
			this.stack = new Array();
		}


		final protected function nextToken():Token
		{
			token = tokenizer.nextToken();
			stack.push(token);
			return token;
		}

		final protected function firstUnmatchedToken():Token
		{
			var n:int = stack.length;
			var item:Object;
			for(var i:int=0; i<n; i++){
				item = stack[i];
				if(item is Token && !(item is SyntaxTreeItem)){
					return item as Token;
				}
			}
			return null;
		}

		final protected function lookAhead(howFar:int=1):Token
		{
			return tokenizer.lookAhead(howFar);
		}


		final protected function skipAhead(howFar:int):void
		{
			tokenizer.skipAhead(howFar);
		}


		protected function restartRule():void
		{
			var marker:RuleMarker = undoRule();
			// XXX: I don't know why I can't just re-use the same marker!!!
			//stack.push(marker);
			startRule(marker.ruleName);
		}



		/**
		 * Indicate that a new rule has begun executing. If the rule matches invoke match() and
		 * then return true. Otherwise invoke didntMatch() and return false.
		 *
		 * @param ruleName String
		 *
		 */
		final protected function startRule(ruleName:String):void
		{
			var marker:RuleMarker = new RuleMarker(getState(), ruleName);
			stack.push(marker);
		}


		/**
		 * Return from a rule function by calling this method, to indicate that the rule did
		 * not match. didntMatch() always returns false.
		 *
		 * @return Boolean; false.
		 */
		final protected function didntMatch():Boolean
		{
			if(stack.length > 0){
				undoRule();
			}
			return false;
		}


		private function undoRule():RuleMarker
		{
			//var t:Object;
			var marker:RuleMarker;
			while(!(marker = (stack.pop() as RuleMarker)));
			restoreState(marker.treeState);
			return marker;
		}


		/**
		 * Return match() to break out of a rule function to indicate that the rule matched.
		 * match() always returns true.
		 *
		 * @return Boolean; true.
		 */
		final protected function match():Boolean
		{
			var stackItem:Object;
			var newTokenChildren:Array = new Array();

			while((stackItem = stack.pop()) is Token){
				lastMatchedToken = stackItem as Token;
				newTokenChildren.unshift(lastMatchedToken);
			}

			var tokenType:String = RuleMarker(stackItem).ruleName;
			var newToken:SyntaxTreeItem = createTreeItem(
				tokenType,
				newTokenChildren,
				// this is either the first child or the previously matched source index (for empty matches)
				lastMatchedToken.sourceIndex
			);
			stack.push(newToken);
			ruleMatched(newToken);
			// this.token = newToken;
			return true;
		}


		/**
		 *
		 */
		protected function createTreeItem(type:String, children:Array, sourceIndex:int):SyntaxTreeItem
		{
			return new SyntaxTreeItem(type, children, null, sourceIndex);
		}


		/**
		 * Extension hook. Override this method to execute code when items are added to the
		 * Abstract Tree. For example, you can build a concrete data structure in parallel.
		 */
		protected function ruleMatched(item:SyntaxTreeItem):void
		{

		}



//		// TODO: Decide if these methods are useful or not
//
//		final protected function replaceToken(newToken:Token):void
//		{
//			var n:int = stack.length;
//			// loop to get past any RuleMarkers that could be on the same stack
//			// TODO: hmm the loop shouldn't be necessary... in theory, if a token has been retrieved
//			// during a rule then it should be on top of the stack..
//			while(n--){
//				if(stack[n] is Token){
//					stack.splice(n, 1, newToken);
//					token = newToken;
//					break;
//				}
//			}
//		}
//
//		final protected function condenseToken(recurse:Boolean=false):void
//		{
//			var tok:SyntaxTreeItem;
//			if((tok = stack[stack.length-1] as SyntaxTreeItem) != null){
//				if(tok.children.length == 1 && tok.children[0] is SyntaxTreeItem){
//					stack[stack.length-1] = tok.children[0];
//				}
//			}
//		}

		/**
		 *
		 */
		final protected function discardToken():void
		{
			var stackItem:Object = stack[stack.length-1];
			if(stackItem is Token){
				stack.pop();
			}
		}



		protected function getState():SyntaxTreeState
		{
			return new SyntaxTreeState(
				SyntaxTreeState.constructorKey,
				stack,
				token,
				tokenizer.getState()
			);
		}

		protected function restoreState(state:SyntaxTreeState):void
		{
			tokenizer.restoreState(state.tokenizerState);
			stack = state.stack;
			token = state.token;
			//var stackDiff:int = stack.length - state.stackLength;
			//stack = stack.slice(0, state.stackLength);
		}
	}
}





import memorphic.parser.SyntaxTreeState;

/**
 * RuleMarker is inserted onto the token stack to indicate where a new rule began
 * and holds the tree state before the rule was applied so that it can be restored
 * if the rule does not match
 */
class RuleMarker {

	/**
	 * The current state of the SyntaxTree when the rule began executing. This is used
	 * to restore the state if the rule does not make a match so that subsequent rules
	 * can start from the same point
	 */
	public var treeState:SyntaxTreeState;

	/**
	 * The name of the rule that is being invoked
	 */
	public var ruleName:String;

	/**
	 *
	 * @param treeState The state of the Syntax tree when the rule was started
	 * @param ruleName The name of the rule that has been started
	 */
	public function RuleMarker(treeState:SyntaxTreeState, ruleName:String)
	{
		this.treeState = treeState;
		this.ruleName = ruleName;
	}
}




