package memorphic.xpath.model
{
	import memorphic.utils.XMLUtil;
	
	public class LocationPath implements IExpression
	{
		
		public var steps:Array; // of Step
		public var absolute:Boolean;
		
		public function LocationPath(absolute:Boolean)
		{
			steps = new Array();
			this.absolute = absolute;
		}
		
		
		private function chooseContext(node:XML):XML
		{
			return absolute ? XMLUtil.rootNode(node) : node;
		}
		
		
		
		public function selectXMLList(context:XPathContext):XMLList
		{
			var numSteps:int = steps.length;
			var step:Step;
			var result:XMLList = <></> + chooseContext(context.contextNode);
			for(var i:int=0; i<numSteps; i++){
				step = steps[i] as Step;
				result = applyStep(result, step, context);
			}
			return result;
		}
		
		public function exec(context:XPathContext):Object
		{
			return selectXMLList(context);
		}
		
		private function applyStep(nodes:XMLList, step:Step, context:XPathContext):XMLList
		{
			var result:XMLList = new XMLList();
			var n:int = nodes.length();
			for(var i:int=0; i<n; i++){
				context = context.copy(false);
				context.contextNode = nodes[i];
				context.contextPosition = i;
				context.contextSize = n;
				result = XMLUtil.concatXMLLists(result, step.selectXMLList(context));
			}
			return result;
		}
		
	
		
		public function execRoot(xml:XML, context:XPathContext):XMLList
		{
			// xpath requires root "/" to be parent of the document root. We also need
			// an XMLList instead of XML
			var wrappedXML:XMLList = <><parent-of-root/></>;
			XML(wrappedXML).appendChild(xml);
			context.contextNode = wrappedXML[0];
			context.contextPosition = 0;
			context.contextSize = 1;
			return selectXMLList(context);
		}
	}
}