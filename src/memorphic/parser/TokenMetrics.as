package memorphic.parser
{
	public class TokenMetrics
	{
		public var sourceIndex:int;
		public var line:int;
		public var column:int;
		public var length:int;
		
		public function TokenMetrics(sourceIndex:int, line:int, column:int, length:int)
		{
			this.sourceIndex = sourceIndex;
			this.line = line;
			this.column = column;
			this.length = length;
		}
	}

}