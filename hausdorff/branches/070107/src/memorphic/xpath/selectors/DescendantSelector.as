package memorphic.xpath.selectors
{
	public class DescendantSelector implements IXPathSelector
	{

		public var nodeName:String;

		public function DescendantSelector(identifier:String="*"){
			nodeName = identifier;
		}

		public function selectAllMatches(context:XMLList):XMLList{
			return context.descendants(nodeName);
		}
	}
}