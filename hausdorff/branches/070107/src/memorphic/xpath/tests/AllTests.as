package memorphic.xpath.tests
{
	import flexunit.framework.TestSuite;

	public class AllTests extends TestSuite
	{
		public static function suite() : TestSuite
		{
			var testSuite:TestSuite = new TestSuite();

			testSuite.addTestSuite( ChildSelectorTest );
			testSuite.addTestSuite( AttributeSelectorTest );
			testSuite.addTestSuite( XPathQueryTest );

			return testSuite;

		}
	}
}