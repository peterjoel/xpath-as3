package memorphic.parser
{
	public class TreeWalker
	{
		
		
		private var currentItem:Token;
		private var rootItem:Token;
		
		public function TreeWalker(root:Token)
		{
			rootItem = root;
		}
		
		public function nextItem():Token
		{
			if(!currentItem){
				currentItem = firstItem();
			}else if (currentItem==rootItem){
				return null;
			}else {
				currentItem = getNext(currentItem);
			}
			return currentItem;
		}
		

		
		private function getNext(item:Token):Token
		{
			var parent:Token = item.parent;
			var childIndex:int = parent.children.indexOf(item) + 1;
			if(childIndex == parent.children.length){
				// last child so return parent
				return parent;
			}else{
				var next:Token = getFirstItemInside(parent.children[childIndex]);
				if(item == next){
					// no more children so go up a level
					return getNext(parent);
				}else{
					return next;
				}
			}
		}
		
		
		private function getFirstItemInside(item:Token):Token
		{
			var children:Array;
			do {
				children = item.children;
				if(children && children.length > 0) {
					item = children[0];
				}else{
					break;
				}
			}
			while (true);
			
			return item;
		}
		private function firstItem():Token
		{
			return getFirstItemInside(rootItem);
		}
		
		public function reset():void
		{
			currentItem = null;
		}

	}
}