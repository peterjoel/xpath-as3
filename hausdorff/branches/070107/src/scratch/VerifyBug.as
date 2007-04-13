package scratch
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import flash.net.getClassByAlias;
	import flash.utils.getDefinitionByName;

	public class VerifyBug
	{
		public function VerifyBug(arg:Boolean=true){
			//test = true;
			var tt:TestThing = new TestThing();
			var f:Object = tt.getUtil();
			var clsName:String = getQualifiedClassName(f);
			var cls:Class = getDefinitionByName(clsName) as Class;
			var tt2:* = new cls();
		}
	}
}