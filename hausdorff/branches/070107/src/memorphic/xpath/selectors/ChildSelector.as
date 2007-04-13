package memorphic.xpath.selectors
{
	public class ChildSelector implements IXPathSelector
	{

		public var nodeName:String;

		public function ChildSelector(identifier:String="*"){
			nodeName = identifier;
		}

		public function selectAllMatches(context:XMLList):XMLList{
			return context.child(nodeName);
		}


		public function selectFirstMatch(context:XMLList):XML{
			return selectAllMatches(context)[0];
		}
	}
}