

package memorphic.parser
{
		
	
	public class SyntaxTreeItem extends Token
	{

		public function SyntaxTreeItem(type:String, children:Array, value:String, sourceIndex:int)
		{
			super(type, value, sourceIndex);
			this.children = children;
			for each(var child:Token in children){
				child.parent = this;
			}
		}
	}
}