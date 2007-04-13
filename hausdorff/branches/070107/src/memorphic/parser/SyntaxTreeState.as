package memorphic.parser
{
	public class SyntaxTreeState
	{
		// TODO: change props to all internal
		
		// key used to emulate an internal constructor
		internal static const constructorKey:Object = {};
		
		public var tokenizerState:TokenizerState;
		public var stack:Array;
		public var token:Token;

		public function SyntaxTreeState(key:Object, stack:Array, token:Token, tokenizerState:TokenizerState){
			if(key != constructorKey){
				throw new Error("TokenizerState is internal to memorphic.parser.* and may not be instantiated");
			}
			this.stack = stack.concat();
			this.tokenizerState = tokenizerState;
			this.token = token;
		}
	}
}