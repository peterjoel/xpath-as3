package memorphic.xpath
{
	public class XPathEnvironment
	{
		
		public var variables:Object;
		public var namespaces:Object;
		public var functions:Object;
		
		public function XPathEnvironment()
		{
			variables = new Object();
			namespaces = new Object();
			functions = new Object();
		}
	}
}