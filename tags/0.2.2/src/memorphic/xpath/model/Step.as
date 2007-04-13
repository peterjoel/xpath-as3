package memorphic.xpath.model
{
	/**
	 * 
	 * [From spec]
	 * 
	 * 2.1 Location Steps
	 * 
	 * A location step has three parts:
	 * 
	 * 	- an axis, which specifies the tree relationship between the nodes selected by the location step and 
	 * 		the context node,
	 *  - a node test, which specifies the node type and expanded-name of the nodes selected by the location 
	 * 		step, and
	 * 	- zero or more predicates, which use arbitrary expressions to further refine the set of nodes selected 
	 * 		by the location step.
	 * 
	 * The syntax for a location step is the axis name and node test separated by a double colon, followed by 
	 * zero or more expressions each in square brackets. For example, in child::para[position()=1], child is 
	 * the name of the axis, para is the node test and [position()=1] is a predicate.
	 * 
	 * The node-set selected by the location step is the node-set that results from generating an initial 
	 * node-set from the axis and node-test, and then filtering that node-set by each of the predicates in turn.
	 * 
	 * The initial node-set consists of the nodes having the relationship to the context node specified by the 
	 * axis, and having the node type and expanded-name specified by the node test. For example, a location step 
	 * descendant::para selects the para element descendants of the context node: descendant specifies that each 
	 * node in the initial node-set must be a descendant of the context; para specifies that each node in the 
	 * initial node-set must be an element named para. The available axes are described in [2.2 Axes]. The 
	 * available node tests are described in [2.3 Node Tests]. The meaning of some node tests is dependent on 
	 * the axis.
	 * 
	 * The initial node-set is filtered by the first predicate to generate a new node-set; this new node-set is 
	 * then filtered using the second predicate, and so on. The final node-set is the node-set selected by the 
	 * location step. The axis affects how the expression in each predicate is evaluated and so the semantics of 
	 * a predicate is defined with respect to an axis. See [2.4 Predicates].
	 * 
	 * Location Steps
	 * 
	 * 		[4] Step ::= 
	 * 				AxisSpecifier NodeTest Predicate*	
	 * 				| AbbreviatedStep	
	 * 
	 * 		[5] AxisSpecifier ::=
	 * 				AxisName '::'	
	 * 				| AbbreviatedAxisSpecifier
	 * 
	 *  	
	 */ 
	public class Step
	{
		
		public var axis:Axis;
		public var nodeTest:INodeTest;
		
		public var predicateList:PredicateList;
		
		
		public function Step(axis:Axis, nodeTest:INodeTest, predicateList:PredicateList)
		{
			this.axis = axis;
			this.nodeTest = nodeTest;
			this.predicateList = predicateList;
		}
		
		
		
		
		public function selectXMLList(context:XPathContext):XMLList
		{
			var result:XMLList;
			
			// :: Axis ::
			var nodeList:XMLList = axis.selectAxis(context);
			
			// :: NodeTest :: 
			nodeList = filterByNodeTest(nodeList, context);
			
			// :: Predicates ::
			if(predicateList == null || nodeList.length() == 0){
				result = nodeList;
			}else{
				result = predicateList.filter(nodeList, context);
			}
			
			return result;

		}
		
		
		
		private function filterByNodeTest(axis:XMLList, context:XPathContext):XMLList
		{
			var result:XMLList = new XMLList();
			var axisNode:XML;
			var axisLength:int = axis.length();
			
			var nodeTestContext:XPathContext;
			
			for (var i:int=0; i<axisLength; i++){
				axisNode = axis[i];
				nodeTestContext = context.copy(false);
				nodeTestContext.contextNode = axisNode;
				nodeTestContext.contextPosition = i;
				nodeTestContext.contextSize = axisLength;
				if(nodeTest.test(nodeTestContext)){
					result += axisNode;
				}
			}	
			return result;	
		}
		
		

	}
}
	




