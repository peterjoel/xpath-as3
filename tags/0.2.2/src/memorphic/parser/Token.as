package memorphic.parser
{
	public class Token
	{


		public var value:String;
		public var tokenType:String;
		public var sourceIndex:int;
		internal var discard:Boolean;
		
		public var parent:Token;
		public var children:Array;

		public function Token(type:String, value:String, sourceIndex:int)
		{
			this.value = value;
			this.tokenType = type;
			this.sourceIndex = sourceIndex;
		}

/*
		public function get length():int
		{
			if(value){
				return value.length;
			}else{
				return 0;
			}
		}
*/		
		
		public function toString():String{
			return "[Token " + tokenType + " : '" + value + "' ("+sourceIndex+") ]";
		}
	}
}