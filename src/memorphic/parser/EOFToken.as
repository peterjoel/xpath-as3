package memorphic.parser
{
	public class EOFToken extends Token
	{
		
		public function EOFToken(sourceIndex:int)
		{
			super("EOF", null, sourceIndex);
		}
	}
}