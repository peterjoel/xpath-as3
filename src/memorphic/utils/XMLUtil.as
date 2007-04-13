package memorphic.utils
{
	public class XMLUtil
	{
		
		
		public static function rootNode(node:XML):XML
		{
			var p:XML = node;
			while(p = p.parent()){
				node = p;
			}
			return node;
		}
		
		public static function concatXMLLists(a:XMLList, b:XMLList):XMLList
		{
			for each(var node:XML in b){
				if(!a.contains(node)){
					a += node;
				}
			}
			return a;
		}
	}
}