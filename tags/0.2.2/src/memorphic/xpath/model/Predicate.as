package memorphic.xpath.model
{
	public class Predicate
	{
		public var expression:IExpression;
		
		public function Predicate(expression:IExpression)
		{
			this.expression = expression;
		}
		
		
		public function test(context:XPathContext):Boolean
		{
			var node:XML = context.contextNode;
			var result:Object = expression.exec(context);
			if(result is Number){
				return context.position() == result;
			}
			return TypeConversions.toBoolean(result);
		}



	}
}