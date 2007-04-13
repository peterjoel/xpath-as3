package memorphic.xpath.selectors
{

	// TODO: verify this is the correct behaviour!

	public class NamespaceSelector implements IXPathSelector
	{


		public var qName:QName;

		public function NamespaceSelector(uri:String){
			qName = new QName(uri, "*");
		}

		public function selectAllMatches(context:XMLList):XMLList{
			return context[qName];
		}

		public function selectFirstMatch(context:XMLList):XML{
			return context[qName][0];
		}
	}
}