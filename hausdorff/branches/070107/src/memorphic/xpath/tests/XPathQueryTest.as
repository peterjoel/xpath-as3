package memorphic.xpath.tests
{
	import flexunit.framework.TestCase;
	import memorphic.xpath.XPathQuery;
	import memorphic.xpath.XPathEnvironment;

	public class XPathQueryTest extends TestCase
	{

		private var instance:XPathQuery;


		public override function setUp():void{
			instance = new XPathQuery(new XPathEnvironment());
		}

		public override function tearDown():void{
			instance = null;
		}


		public function testInstantiated():void{
			assertTrue("instance should be an XPathQuery", instance is XPathQuery);
		}
	}
}