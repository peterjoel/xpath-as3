package memorphic.xpath.selectors
{
	public class AncestorSelector implements IXPathSelector
	{

		public function AncestorSelector(){
		}

		public function selectAllMatches(context:XMLList):XMLList{
			var matches:XMLList = new XMLList();
			var p:XMLList = context;
			while(p = p.parent()){
				matches += p;
			}
			return matches;
		}

		public function selectFirstMatch(context:XMLList):XML{

			return context.parent() as XML;
		}
	}
}