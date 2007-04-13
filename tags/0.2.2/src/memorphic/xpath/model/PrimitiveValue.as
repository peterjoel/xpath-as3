package memorphic.xpath.model
{
	public class PrimitiveValue implements IExpression
	{
		
		public var value:Object;
		
		public function PrimitiveValue(value:Object)
		{
			this.value = value;
		}
		
		public function exec(context:XPathContext):Object
		{
			return value;
		}
		
	}
}