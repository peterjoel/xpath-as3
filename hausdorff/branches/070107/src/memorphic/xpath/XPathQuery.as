package memorphic.xpath
{
	import memorphic.xpath.selectors.IXPathSelector;

	/**
	 *	Manages a sequence of XPath selectors, and can run complex selections
	 */
	public class XPathQuery implements IXPathSelector
	{

		private var environment:XPathEnvironment;

		public function XPathQuery(environment:XPathEnvironment){
			selectors = new Array();
			this.environment = environment;
			reset();

		}


		internal var selectors:Array; // of IXPathSelector
		internal var position:int;


		public function selectAllMatches(context:XMLList):XMLList{
			var selector:IXPathSelector;
			var result:XMLList = context;
			reset();
			while(selector = nextSelector()){
				result = selector.selectAllMatches(result);
			}
			return result;
		}

//		public function selectFirstMatch(context:XMLList):XML{
//			var selector:IXPathSelector;
//			var result:XMLList = context;
//			reset();
//			while(!isLast()){
//				selector = nextSelector()
//				result = selector.selectAllMatches(result);
//			}
//			return selector.selectFirstMatch(result);
//		}

		private function reset():void{
			position = -1;
		}


		private function isLast():Boolean{
			return position == selectors.length;
		}

		private function nextSelector():IXPathSelector{
			position++;
			if(isLast()){
				return null;
			}else{
				return selectors[position] as IXPathSelector;
			}
		}


		public function get length():int{
			return selectors.length;
		}


		public function addSelector(newSelector:IXPathSelector):void{
			selectors.push(newSelector);
		}


	}
}