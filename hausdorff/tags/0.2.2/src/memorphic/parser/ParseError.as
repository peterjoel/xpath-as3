package memorphic.parser
{
	public class ParseError extends Error
	{		
		
		public var tokenMetrics:TokenMetrics;
		
		public function ParseError(message:String, tokenMetrics:TokenMetrics, id:int=0)
		{
			super(message, id);
			
			this.tokenMetrics = tokenMetrics;
		}
	}
}