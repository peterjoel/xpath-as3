package memorphic.parser
{
	
	/**
	 * I would really have liked to make this an inner class of Tokenizer :(
	 */
	public final class TokenizerState
	{
		// key used to emulate an internal constructor
		public static const constructorKey:Object = {};
		public var inputStreamPosition:int;
		public var token:Token;
		public var tokenPosition:int;

		public function TokenizerState(key:Object,
				token:Token,
				inputStreamPosition:int,
				tokenPosition:int )
		{
					
			if(key != constructorKey){
				throw new Error("TokenizerState is internal to memorphic.parser.* and may not be instantiated");
			}
			
			this.inputStreamPosition = inputStreamPosition;
			this.token = token;
			this.tokenPosition = tokenPosition;
		}
	}
}