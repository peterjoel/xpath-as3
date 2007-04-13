package memorphic.xpath.selectors
{
	public class PrecedingSelector implements IXPathSelector
	{


		public function selectAllMatches(context:XMLList):XMLList{
			var match:XMLList = new XMLList();
			var childIndex:int;
			for each(var p:XML in context){
				childIndex = p.childIndex();
				if(childIndex > 0){
					match += p.parent()[childIndex -1];
				}else{
					match += p.parent();
				}
			}
			return match;
		}

		public function selectFirstMatch(context:XMLList):XML{
			var childIndex:int;
			for each(var p:XML in context){
				childIndex = p.childIndex();
				if(childIndex > 0){
					return p.parent[childIndex -1];
				}else{
					return p.parent();
				}
			}
		}
	}
}