package memorphic.xpath.model
{
	public class AxisNames
	{
		public static const ANCESTOR_OR_SELF:String = "ancestor-or-self";
		public static const ANCESTOR:String = "ancestor";
		public static const ATTRIBUTE:String = "attribute";
		public static const CHILD:String = "child";
		public static const DESCENDANT_OR_SELF:String = "descendant-or-self";
		public static const DESCENDANT:String = "descendant";
		public static const FOLLOWING_SIBLING:String = "following-sibling";
		public static const FOLLOWING:String = "following";
		public static const NAMESPACE:String = "namespace";
		public static const PARENT:String = "parent";
		public static const PRECEDING_SIBLING:String = "preceding-sibling";
		public static const PRECEDING:String = "preceding";
		public static const SELF:String = "self";
		
		public static function isAxisName(name:String):Boolean
		{
			switch(name){
			case ANCESTOR_OR_SELF:
			case ANCESTOR:
			case ATTRIBUTE:
			case CHILD:
			case DESCENDANT_OR_SELF:
			case DESCENDANT:
			case FOLLOWING_SIBLING:
			case FOLLOWING:
			case NAMESPACE:
			case PARENT:
			case PRECEDING_SIBLING:
			case PRECEDING:
			case SELF:
				return true;
			default:
				return false;
			}
		}
		
		public static function expandAbbreviatedAxisName(abbr:String):String
		{
			switch(abbr){
			case "":
				return CHILD;
			case "@":
				return ATTRIBUTE;
			default:
				throw new ArgumentError();
			}
		}
		
		

	}
}