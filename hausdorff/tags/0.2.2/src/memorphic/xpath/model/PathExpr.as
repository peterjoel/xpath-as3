package memorphic.xpath.model
{
	import memorphic.utils.XMLUtil;
	
	public class PathExpr implements IExpression
	{
		
		
		public var filterExpr:FilterExpr;
		public var locationPath:LocationPath;
		
		public function PathExpr(filterExpr:FilterExpr, path:LocationPath)
		{
			this.filterExpr = filterExpr;
			this.locationPath = path;
		}
		
		public function exec(context:XPathContext):Object
		{
			return selectXMLList(context);
		}
		
		public function selectXMLList(context:XPathContext):XMLList
		{
			var result:XMLList = new XMLList();
			var filterExprResult:XMLList = filterExpr.selectXMLList(context);
			var len:int = filterExprResult.length();
			context = context.copy(false);
			context.contextSize = len;
			for(var i:int=0; i<len; i++){
				context.contextNode = filterExprResult[i];
				context.contextPosition = i;
				result = XMLUtil.concatXMLLists(result, locationPath.selectXMLList(context));
			}
			
			return result;
		}
		
	}
}