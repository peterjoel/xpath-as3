package memorphic.xpath.selectors
{
	public class AttributeSelector implements IXPathSelector
	{


		public var nodeName:String;

		public function AttributeSelector(identifier:String="*"){
			nodeName = identifier;
		}


		public function selectAllMatches(context:XMLList):XMLList{
			return context.attribute(nodeName);
		}


		public function selectFirstMatch(context:XMLList):XML{
			return selectAllMatches(context)[0];
		}

	}
}