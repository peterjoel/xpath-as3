package memorphic.xpath.model
{
	
		
	/**
	 * 
	 * @see INodeTest
	 * 
	 */ 
	public class NodeTypeTest implements INodeTest {
		
		public var nodeType:String;
		
		public function NodeTypeTest(type:String)
		{
			this.nodeType = type;
		}
		
		public function test(context:XPathContext):Boolean
		{
			return NodeTypes.xmlKindToNodeType(context.contextNode.nodeKind()) == nodeType;
		}
	}
}