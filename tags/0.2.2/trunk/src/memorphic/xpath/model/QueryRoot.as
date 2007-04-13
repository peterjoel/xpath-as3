package memorphic.xpath.model
{
	final public class QueryRoot
	{

		private var expr:IExpression;
		
		
		public function QueryRoot(rootExpr:IExpression)
		{
			expr = rootExpr;
		}
		
		public function execRoot(xml:XML, context:XPathContext):Object
		{
			// xpath requires root "/" to be parent of the document root. We also need
			// an XMLList instead of XML
			var wrappedXML:XMLList = <><parent-of-root/></>;
			XML(wrappedXML).appendChild(xml);
			
			context.contextNode = wrappedXML[0];
			context.contextPosition = 0;
			context.contextSize = 1;
			
			return expr.exec(context);
		}
	}
}