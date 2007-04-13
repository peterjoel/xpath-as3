package memorphic.xpath.tests
{
	import flexunit.framework.Assert;
	import flexunit.framework.TestCase;

	import memorphic.xpath.selectors.ChildSelector;
	import memorphic.xpath.selectors.IXPathSelector;
	import memorphic.xpath.tests.fixtures.XMLData;

	import mx.charts.chartClasses.InstanceCache;

	public class ChildSelectorTest extends TestCase
	{


		public override function setUp():void{

		}

		public override function tearDown():void{

		}


		public function testInstantiated():void{
			assertTrue("ChildSelector not created!", new ChildSelector("child") is ChildSelector);
		}


		public function testFixture():void{
			var sel:IXPathSelector = new ChildSelector("food");
			var result0:XMLList = sel.selectAllMatches(<></>+XMLData.foodMenuXML);
			assertEquals("should select 5", 5, result0.length());
		}

	}
}