package memorphic.xpath.model
{
	public interface IExpression
	{
		
		function exec(context:XPathContext):Object;
		
	}
}