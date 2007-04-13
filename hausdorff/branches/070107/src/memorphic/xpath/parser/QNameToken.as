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
		
		
		public override function get length():int
		{
			return makeQNameValue().length;
		}
		
		private function makeQNameValue():String
		{
			if(prefix == null || prefix == ""){
				return localName;
			}else{
				return prefix+":"+localName
			}
		}
		
		public override function toString():String
		{
			var oldVal:String = value;
			value = makeQNameValue();
			var str:String = super.toString();
			value = oldVal;
			return str;
		}
	}
}