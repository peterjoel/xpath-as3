package memorphic.xpath.selectors
{
	public class FollowingSelector implements IXPathSelector
	{


		public function selectAllMatches(context:XMLList):XMLList{
			var match:XMLList = new XMLList();
			var childIndex:int;
			var parent:XML;
			for each(var p:XML in context){
				childIndex = p.childIndex();
				parent = p.parent();
				if(childIndex < parent.length() - 1){
					match += parent[childIndex +1];
				}else{
					match += parent;
				}
			}
			return match;
		}

		public function selectFirstMatch(context:XMLList):XML{
			var childIndex:int;
			var parent:XML;
			for each(var p:XML in context){
				childIndex = p.childIndex();
				parent = p.parent();
				if(childIndex < parent.length() - 1){
					return parent[childIndex +1];
				}else{
					return parent;
				}
			}
		}
	}
}