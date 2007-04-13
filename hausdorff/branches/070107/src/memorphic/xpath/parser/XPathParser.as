package memorphic.xpath.parser
{
	import memorphic.parser.SyntaxTreeItem;
	import memorphic.parser.Token;
	import memorphic.xpath.XPathQuery;
	//import memorphic.xpath.selectors.DescendentOrSelfSelector;
	import memorphic.xpath.selectors.SelfSelector;
	import memorphic.xpath.XPathEnvironment;

	public final class XPathParser
	{
		private var tokenizer:XPathTokenizer;
		private var syntaxTree:XPathSyntaxTree;

		public var query:XPathQuery;


		public function XPathParser(){
			tokenizer = new XPathTokenizer();
			syntaxTree = new XPathSyntaxTree(tokenizer);
		}



		public function parse(data:String):void
		{
			tokenizer.rawData = data;
			var tree:SyntaxTreeItem = syntaxTree.getTree();
			//query = new XPathQuery(new XPathEnvironment());
			// parseLocationPath(tree);
			trace(itemToString(tree));
		}

		private function parseLocationPath(item:SyntaxTreeItem):void
		{
			var root:SyntaxTreeItem = item.children[0] as SyntaxTreeItem;
			var relPath:SyntaxTreeItem;
			if(root.tokenType == XPathSyntaxTree.ABSOLUTE_LOCATION_PATH){
				if(Token(root.children[0]).value == "//"){
					//query.addSelector(new DescendentOrSelfSelector());
				}else{
					query.addSelector(new SelfSelector());
				}
				relPath = SyntaxTreeItem(root.children[1]);
			}else{

			}

		}



		namespace temp;
		use namespace temp;

		temp var depth:int = 0;
		temp function itemToString(item:Token):String
		{
			var str:String = temp::pad() + "- " + item.toString();
			if(item is SyntaxTreeItem){
				var ch:Array = SyntaxTreeItem(item).children;
				if(ch != null){
					var n:int = ch.length;
					temp::depth++;
					for(var i:int=0; i<n; i++){
						str+= "\n" + itemToString(ch[i]);
					}
				}
				temp::depth--;
			}
			return str;
		}
		temp function pad():String
		{
			var n:int = temp::depth;
			var str:String = "";
			while(n--){
				str += " ";
			}
			return str;
		}


	}
}