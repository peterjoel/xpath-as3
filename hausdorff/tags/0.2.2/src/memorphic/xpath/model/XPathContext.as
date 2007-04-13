package memorphic.xpath.model
{
	
	public class XPathContext
	{
		
		

		internal static var defaultNamespaces:Object = new StandardNamespaces();
		
		internal static var defaultFunctions:Object = new StandardFunctions();
		
		
		/**
		 * A table of variable references to use inside XPath statements.
		 * 
		 * For example:
		 * 
		 * var xpath:XPathQuery = new XPathQuery("foo/bar[@id=$nodeID]");
		 * xpath.context.variables.nodeID = "x";
	 	 */		
		public var variables:Object;
		
		
		/**
		 * 
	 	 */		
		public var namespaces:Object;
		
		
		/**
		 * Any function references that you add to this object will be accessible in your XPath statements, using the name that you assign it to.
		 * The first argument must be of type XPathContext. Remaining arguments must match those passed to the function inside the statement.
		 * 
		 * For example:
		 * 
		 * <code>
		 * 	function formatNumber(context:XPathContext, arg1:Number):String
		 * 	{
		 * 		return new NumberFormat("####.##").format(arg1);
		 * 	}
		 * 
		 *  .....
		 * 
		 *  myXPathQuery.context.functions["format-number"] = formatNumber;
		 * 
		 * </code>
	 	 */		
		public var functions:Object;
		
		
		
		public var zeroIndexPosition:Boolean = false;
		
		public var openAllNamespaces:Boolean = false;
		
				
		
		internal var contextNode:XML;
		internal var contextPosition:int;
		internal var contextSize:int;

		
		
		public function XPathContext()
		{
			variables = new Object();
			namespaces = new Object();
			functions = new Object();
			
			
		}



		
		
		
		internal function getNamespace(prefix:String):String
		{
			if(namespaces.hasOwnProperty(prefix)){
				return namespaces[prefix];
			}else{
				return defaultNamespaces[prefix];
			}
		}
		
		

		/**
		 * 
		 * @param name Can be a String or QName
		 * 
		 */		 
		internal function getVariable(name:*):Object
		{
			return variables[name];
		}
		

		
		/**
		 * 
		 * @param name Can be a String or QName
		 * 
		 */	
		internal function getFunction(name:*):Function
		{
			if(functions.hasOwnProperty(name)){
				return functions[name] as Function;
			}else{
				return defaultFunctions[name] as Function;
			}
		}

		/**
		 * 
		 * @param name Can be a String or QName
		 * 
		 */	
		internal function callFunction(name:Object, args:Array=null):Object
		{
			var applyArgs:Array = [this];
			if(args != null){
				applyArgs = applyArgs.concat(args);
			}
			return getFunction(name).apply(null, applyArgs);
		}
		
		
		/**
		 * Creates a copy of an XPathContext object
		 * @param deepCopy
		 */ 
		public function copy(deepCopy:Boolean=true):XPathContext
		{
			var context:XPathContext = new XPathContext();
			if(deepCopy){
				copyDynamicProps(functions, context.functions);
				copyDynamicProps(namespaces, context.namespaces);
				copyDynamicProps(variables, context.variables);
			}else{
				context.functions = functions;
				context.namespaces = namespaces;
				context.variables = variables;
			}
			context.contextNode = contextNode;
			context.contextPosition = contextPosition;
			context.contextSize = contextSize;
			context.zeroIndexPosition = zeroIndexPosition;
			context.openAllNamespaces = openAllNamespaces;
			return context;
		}
		
		
		private function copyDynamicProps(from:Object, to:Object):void
		{
			for(var p:String in from){
				to[p] = from[p];
			}
		}
		
		
		/**
		 * Inside a predicate, position() represents the index of the current context node, within the node set.
		 * According to the w3c spec, position() is 1-indexed, so the first node will have index 1. 
		 * 
		 * Some XPath implementations (notably Microsoft's) are zero indexed. You can change to this behaviour 
		 * using the <code>zeroIndexPosition</code> property.
		 * 
		 * 
		 * This method is provided for use within custom functions.
		 */ 
		public function position():int
		{
			//return contextPosition;
			return zeroIndexPosition ? contextPosition : contextPosition + 1;
		}
		
		/**
		 * Inside a predicate, last() represents the size of the current node set and the maximum value of <code>position()>/code>.
		 * This method is provided for use within custom functions.
		 */ 
		public function last():int
		{
			return contextSize;
		}
		
		/**
		 * Inside a predicate, node() represents the current node, on which the predicate is acting.
		 * This method is provided for use within custom functions.
		 */ 
		public function node():XML
		{
			return contextNode;
		}
	}
}



