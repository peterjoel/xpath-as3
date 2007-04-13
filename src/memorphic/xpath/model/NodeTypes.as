package memorphic.xpath.model
{
	public class NodeTypes
	{
		public static const COMMENT:String = "comment";
		public static const TEXT:String = "text";
		public static const PROCESSING_INSTRUCTION:String = "processing-instruction";
		public static const NODE:String = "node";
		
		
		
		public static function isNodeType(test:String):Boolean
		{
			switch(test){
			case COMMENT: case TEXT:
			case PROCESSING_INSTRUCTION: case NODE:
				return true;
			default:
				return false;
			}
		}
		
		
		public static function xmlKindToNodeType(kind:String):String
		{
			// text, comment, processing-instruction, attribute, or element
			switch(kind){
			case COMMENT: case TEXT: case PROCESSING_INSTRUCTION:
				return kind;
			case "element":
				return NODE;
			default:
				// including "attribute" which is handled as an Axis in XPath
				throw new Error("cannot convert '" + kind + "' to an XPath NodeType");
			}
		}
		
	}
}