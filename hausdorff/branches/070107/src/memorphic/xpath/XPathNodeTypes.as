package memorphic.xpath
{
	public class XPathNodeTypes
	{

		public static const COMMENT:String = "comment";
		public static const TEXT:String = "text";
		public static const PROCESSING_INSTRUCTION:String = "processing-instruction";
		public static const NODE:String = "node";
		
		
		public static function isNodeType(test:String):Boolean
		{

			switch(test){
			case COMMENT:
			case TEXT:
			case PROCESSING_INSTRUCTION:
			case NODE:
				return true;
			default:
				return false;
			}
		}
	}
}