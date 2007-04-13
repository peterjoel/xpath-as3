package memorphic.xpath.model
{
	
	/**
	 * A list of predicates, extracted into its own class to avoid duplicating the same
	 * functionality in two places: Step and FilterExpr.
	 */ 
	public class PredicateList
	{
		
		
		public var predicates:Array;

		
		public function PredicateList(predicates:Array)
		{
			this.predicates = predicates;
			
		}
		
			
		public function filter(nodeList:XMLList, baseContext:XPathContext):XMLList
		{

			var contextLength:int = nodeList.length();
			var result:XMLList = new XMLList();
			var node:XML;
			var context:XPathContext;
			for(var i:int=0; i<contextLength; i++){
				node = nodeList[i];
				context = baseContext.copy(false);
				context.contextNode = node;
				context.contextPosition = i;
				context.contextSize = contextLength;
				if(testPredicates(context)){
					result += node;
				}
			}
			return result;
		}
		
		
		private function testPredicates(context:XPathContext):Boolean
		{
			var n:int = predicates.length;
			for(var i:int=0; i<n; i++){
				if(!Predicate(predicates[i]).test(context)){
					return false;
				}
			}
			return true;
		}

	}
}