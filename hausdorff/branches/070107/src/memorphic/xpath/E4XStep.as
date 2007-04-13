package memorphic.xpath
{
	import memorphic.xpath.selectors.IXPathSelector;
	import memorphic.xpath.selectors.ChildSelector;
	
	/**
	 * E4XStep Step
	 */
	public class E4XStep implements IXPathSelector
	{
		public var axisAndNameTest:IXPathSelector;
		
		public var predicates:Array;
		
		private var nodeName:*;
		
		public var nodeTest:Object
		
		public function E4XStep(axis:String, nodeTest:*)
		{
			predicates = new Array();
			
			if(nodeTest is QName || nodeTest is String){
				nodeName = nodeTest;
				this.nodeTest = null;
			}else{
				nodeName = "*";
				this.nodeTest = nodeTest;
			}
			
			axisAndNameTest = createAxis(axis);
		}
		
		private function createAxis(axis:String):void
		{
			switch(axis){
			case XPathAxes.ANCESTOR:
			case XPathAxes.ANCESTOR_OR_SELF:
			case XPathAxes.ATTRIBUTE:
			case XPathAxes.CHILD:
			case XPathAxes.DESCENDANT:
			case XPathAxes.DESCENDANT_OR_SELF:
			case XPathAxes.FOLLOWING:
			case XPathAxes.FOLLOWING_SIBLING:
			case XPathAxes.NAMESPACE:
			case XPathAxes.PARENT:
			case XPathAxes.PRECEDING:
			case XPathAxes.PRECEDING_SIBLING:
			case XPathAxes.SELF:
			default:
				// this is just for quick testing
				return new ChildSelector(nodeName);
			}	
		}
		
		public function selectAllMatches(context:XMLList):XMLList
		{
			var nodeSet:XMLList = axisAndNameTest.selectAllMatches(context);
			var n:int = predicates.length;
			for(var i:int=0; i<n; i++){
				nodeSet = IXPathSelector(predicates[i]).selectAllMatches(nodeSet);
			}
		}
		
	}
}
