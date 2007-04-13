package memorphic.xpath
{
	public class XPathAxes
	{

		public static const ANCESTOR:String = "ancestor";
		public static const ANCESTOR_OR_SELF:String = "ancestor-or-self";
		public static const ATTRIBUTE:String = "attribute";
		public static const CHILD:String = "child";
		public static const DESCENDANT:String = "descendant";
		public static const DESCENDANT_OR_SELF:String = "descendant-or-self";
		public static const FOLLOWING:String = "following";
		public static const FOLLOWING_SIBLING:String = "following-sibling";
		public static const NAMESPACE:String = "namespace";
		public static const PARENT:String = "parent";
		public static const PRECEDING:String = "preceding";
		public static const PRECEDING_SIBLING:String = "preceding-sibling";
		public static const SELF:String = "self";

		
		public static const ABBREVIATED_SELF:String = ".";
		public static const ABBREVIATED_PARENT:String = "..";
		
		
		public static function isAxisName(test:String):Boolean
		{
			switch(test){
			case ANCESTOR:
			case ANCESTOR_OR_SELF:
			case ATTRIBUTE:
			case CHILD:
			case DESCENDANT:
			case DESCENDANT_OR_SELF:
			case FOLLOWING:
			case FOLLOWING_SIBLING:
			case NAMESPACE:
			case PARENT:
			case PRECEDING:
			case PRECEDING_SIBLING:
			case SELF:
				return true;
			default:
				return false;
			}
		}
	}
}