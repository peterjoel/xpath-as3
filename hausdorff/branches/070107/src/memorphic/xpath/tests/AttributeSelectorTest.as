package memorphic.xpath.tests
{
	import flexunit.framework.TestCase;
	import memorphic.xpath.selectors.AttributeSelector;
	import mx.charts.chartClasses.InstanceCache;
	import flexunit.framework.Assert;

	public class AttributeSelectorTest extends TestCase
	{

		public var instance:AttributeSelector;
		public var wildInstance:AttributeSelector;

		public var childName:String = "child";
		public var parentName:String = "parent";

		public var testXML0Children:XML = <root><a /><b /><c /><d /><e /></root>;
		public var testXML1Child:XML = <root><child /></root>;
		public var testXML4Children:XML = <root><child /><child /><child /><child /></root>;
		public var testXMLNestedChildren:XML = <root>
													<parent><child /></parent>
													<parent><child /></parent>
													<parent><child /></parent>
													</root>;
		public var testXMLNestedMixedChildren:XML = <root>
													<parent><childA /></parent>
													<parent><child /></parent>
													<parent><childB /></parent>
													<parent><childC /></parent>
													<parent><child /></parent>
													<parent><childD /></parent>
													<parent><childE /></parent>
													<parent><child /></parent>
													<parent><childF /></parent>
													</root>;

		public override function setUp():void{

			instance = new AttributeSelector(childName);
			wildInstance = new AttributeSelector("*");

		}

		public override function tearDown():void{
			instance = null;
			wildInstance = null;
		}


		public function testInstantiated():void{

			assertTrue("AttributeSelector not created!", instance is AttributeSelector);
		}

		public function testSelectNodes():void{

			var result0:XMLList = instance.selectAllMatches(new XMLList(testXML0Children));
			assertEquals("no items should be selected", 0, result0.length());


			var result1:XMLList = instance.selectAllMatches(new XMLList(testXML1Child));
			assertEquals("one item should be selected", 1, result1.length());
			assertEquals("selected child should be have name '"+childName+"'", XML(result1[0]).name(), childName);


			var result2:XMLList = instance.selectAllMatches(new XMLList(testXML4Children));
			assertEquals("4 items should be selected", 4, result2.length());
			for each(var node:XML in result2){
				assertEquals("each selected child should be have name '"+childName+"'", node.name(), childName);
			}



			var result3:XMLList = instance.selectAllMatches(new XMLList(testXMLNestedChildren));
			assertEquals("no items should be selected", 0, result3.length());

			var result4:XMLList = instance.selectAllMatches(testXMLNestedChildren.parent);
			assertEquals("3 items should be selected", 3, result4.length());
			for each(node in result4){
				assertEquals("each selected child should be have name '"+childName+"'", node.name(), childName);
			}


			var result5:XMLList = instance.selectAllMatches(testXMLNestedMixedChildren.parent);
			assertEquals("3 items should be selected", 3, result5.length());
			for each(node in result5){
				assertEquals("each selected child should be have name '"+childName+"'", node.name(), childName);
			}
		}

		public function testWildcardSelect():void{

			var result0:XMLList = wildInstance.selectAllMatches(new XMLList(testXML0Children));
			assertEquals("5 items should be selected", 5, result0.length());

			var result1:XMLList = wildInstance.selectAllMatches(new XMLList(testXML1Child));
			assertEquals("one item should be selected", 1, result1.length());

			var result2:XMLList = wildInstance.selectAllMatches(new XMLList(testXML4Children));
			assertEquals("4 items should be selected", 4, result2.length());

			var result3:XMLList = wildInstance.selectAllMatches(new XMLList(testXMLNestedChildren));
			assertEquals("3 items should be selected", 3, result3.length());
			for each(var node:XML in result3){
				assertEquals("each selected child should be have name '"+parentName+"'", node.name(), parentName);
			}

			var result4:XMLList = wildInstance.selectAllMatches(testXMLNestedChildren.parent);
			assertEquals("3 items should be selected", 3, result4.length());

			var result5:XMLList = wildInstance.selectAllMatches(testXMLNestedMixedChildren.parent);
			assertEquals("9 items should be selected", 9, result5.length());

		}

	}
}