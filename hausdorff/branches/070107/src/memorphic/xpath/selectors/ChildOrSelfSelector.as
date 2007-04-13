package memorphic.xpath.selectors
{
	public class ChildOrSelfSelector implements IXPathSelector
	{

		public var nodeName:String;

		public function ChildOrSelfSelector(identifier:String="*"){
			nodeName = identifier;
		}

		public function selectAllMatches(context:XMLList):XMLList{
			return context + context.child(nodeName);
		}


		public function selectFirstMatch(context:XMLList):XML{
			return selectAllMatches(context)[0];
		}
	}
}