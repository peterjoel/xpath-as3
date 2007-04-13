package memorphic.xpath.model
{
	import memorphic.xpath.model.XPathContext;
	
	/**
	 * 
	 * @see INodeTest
	 * 
	 */ 
	public class NameTest implements INodeTest {
		
		
		public var prefix:String;
		public var localName:String;
		
		public function NameTest(prefix:String, localName:String)
		{
			this.prefix = prefix;
			this.localName = localName;
			
		}
		
		
		
		
		public function test(context:XPathContext):Boolean
		{
			var node:XML = context.contextNode;
			if(context.openAllNamespaces || prefix=="*"){
				if(localName == "*"){
					return true;
				}else {
					return node.localName() == localName;
				}
			}else if(!prefix){
				return localName == "*" || node.name() == localName;
			}else{
				var uri:String = context.namespaces[prefix];
				if(uri == null){
					// TODO: find a better error type
					throw new Error("There is no namespace mapped to the prefix '"+prefix+"'.");
					
				}else{
					return (node.localName()==localName && node.namespace().uri == uri);
				}
			}
		}
		
	}

}