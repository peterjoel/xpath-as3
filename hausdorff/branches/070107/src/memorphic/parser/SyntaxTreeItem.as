

package memorphic.parser {
		
	
	public class SyntaxTreeItem extends Token
	{
		public var children:Array;
		
		
		public function SyntaxTreeItem(type:String, children:Array, value:String, sourceIndex:int)
		{
			super(type, value, sourceIndex);
			this.children = children;
		}
	}
}