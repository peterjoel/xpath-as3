package memorphic.xpath.model
{
	public class VariableReference implements IExpression
	{
		
		
		public var prefix:String;
		public var localName:String;
		
		
		public function VariableReference(prefix:String, localName:String)
		{
			this.prefix = prefix;
			this.localName = localName;
		}
		
		
		public function exec(context:XPathContext):Object
		{
			return context.getVariable(getVarName(context));
		}
		
		
		private function getVarName(context:XPathContext):Object
		{
			if(prefix){
				return new QName(context.getNamespace(prefix), localName);
			}else{
				return localName;
			}
		}
	}
}