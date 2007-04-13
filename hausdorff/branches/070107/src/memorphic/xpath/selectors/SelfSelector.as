package memorphic.xpath.selectors
{
	public class SelfSelector implements IXPathSelector
	{

		public function selectAllMatches(context:XMLList):XMLList{
			return context;
		}

		public function selectFirstMatch(context:XMLList):XML{
			return context[0] as XML;
		}
	}
}