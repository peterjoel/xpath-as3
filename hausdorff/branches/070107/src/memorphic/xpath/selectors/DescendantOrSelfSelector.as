package memorphic.xpath.selectors
{
	public class DescendentOrSelfSelector implements IXPathSelector
	{


		public var nodeName:String;

		public function DescendentOrSelfSelector(identifier:String="*"){
			nodeName = identifier;
		}

		public function selectAllMatches(context:XMLList):XMLList{
			return context + context.descendants(nodeName);
		}


		public function selectFirstMatch(context:XMLList):XML{
			var matches:XMLList = context.descendants(nodeName);
			if(matches.length > 0){
				return matches[0] as XML;
			}else{
				return context[0] as XML;
			}
		}
	}
}