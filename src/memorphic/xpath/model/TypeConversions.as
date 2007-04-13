package memorphic.xpath.model
{
	public class TypeConversions
	{
		
		
		
		public static function toXMLList(a:Object):XMLList
		{
			if(a is XMLList){
				return a as XMLList;
			}else if(a is XML){
				return XMLList(a);
			}else{
				throw new TypeError("Cannot convert '"+a+"' to an XMLList.");
			}
		}
		
		public static function toString(a:Object):String
		{
			if(a is String){
				return a as String;
			}else if(a is Boolean){
				return a ? "true" : "false";
			}else if(a is Number){
				return a.toString();
			}else if(a is XMLList){
				if(a.length() == 0){
					return "";
				}else{
					// TODO: test that this meets the spec requirements
					return a[0].toString();
				}
			//}else if(a is XML){
			//	return a.toString();
			}else{
				return a.toString();
			}
		}
		
		public static function toNumber(a:Object):Number
		{
			if(a is Number){
				return a as Number;
			}else if(a is String){
				return parseFloat(a as String);
			}else if(a is Boolean){
				return a ? 1 : 0;
			}else if(a is XMLList || a is XML){
				return parseFloat(toString(a));
			}else{
				return parseFloat(a.toString());
			}
		}
		
		
		
		public static function toBoolean(a:Object):Boolean
		{
			if(a is Boolean){
				return a as Boolean;
			}else if(a is Number){
				return a != 0;
			}else if(a is String){
				return a != "";
			}else if(a is XMLList){
				return XMLList(a).length() > 0;
			}else if(a is XML){
				return true;
			}else{
				return Boolean(a);
			}
		}
	}
}