package memorphic.xpath.selectors
{
	public class ParentSelector implements IXPathSelector
	{

		public function ParentSelector(){
		}

		public function selectAllMatches(context:XMLList):XMLList{
			return context.parent();
		}
		public function selectFirstMatch(context:XMLList):XMLList{
			return selectAllMatches(context) || null;
		}
	}
}