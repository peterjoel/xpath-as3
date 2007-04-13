package memorphic.xpath.model
{
	public class FunctionCall implements IExpression
	{
		
		
		public var functionName:String;
		
		public var args:Array; // of IExpression
		
		
		public function FunctionCall(funcName:String, args:Array)
		{
			this.functionName = funcName;
			this.args = args;
		}
		
		public function exec(context:XPathContext):Object
		{
			var funcArgs:Array = new Array();
			var n:int = args.length;
			for(var i:int=0; i<n; i++){
				funcArgs[i] = IExpression(args[i]).exec(context);
			}
			return context.callFunction(functionName, funcArgs);
		}
		
	}
}