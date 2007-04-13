package memorphic.xpath.selectors
{
	public interface IXPathSelector
	{
		function selectAllMatches(context:XMLList):XMLList;
	}
}