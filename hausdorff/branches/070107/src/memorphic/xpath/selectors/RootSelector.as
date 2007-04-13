package memorphic.xpath.selectors
{
	public class RootSelector implements IXPathSelector
	{

		public function selectAllMatches(context:XMLList):XMLList{

			return selectFirstMatch(context) as XMLList;
		}

		public function selectFirstMatch(context:XMLList):XML{
			var p:XMLList = context;
			while(p != null){
				context = p;
				p = context.parent();
			}
			return context;
		}
	}
}