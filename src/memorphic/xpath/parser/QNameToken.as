package memorphic.xpath.parser
{
	import memorphic.parser.Token;

	public class QNameToken extends Token
	{
		
		public var prefix:String;
		public var localName:String;
		
		public function QNameToken(type:String, prefix:String, localName:String, sourceIndex:int)
		{
			super(type, null, sourceIndex);
			
			this.prefix = prefix;
			this.localName = localName;
		}
		
	
	}
}