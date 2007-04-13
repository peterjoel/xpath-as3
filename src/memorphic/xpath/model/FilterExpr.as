package memorphic.xpath.model
{
	public class FilterExpr implements IExpression
	{
		
		public var primaryExpr:IExpression;
		public var predicateList:PredicateList;
		
		
		
		public function FilterExpr(primaryExpr:IExpression, predicateList:PredicateList)
		{
			this.primaryExpr = primaryExpr;
			this.predicateList = predicateList;
		}
		
		public function selectXMLList(context:XPathContext):XMLList
		{
			
			var result:XMLList = primaryExpr.exec(context) as XMLList;
			
			if(predicateList != null && result.length() > 0){
				result = predicateList.filter(result, context);
			}
			return result;
			
		}
		
		public function exec(context:XPathContext):Object
		{	
			return selectXMLList(context);
		}
		
	

		
	}
}