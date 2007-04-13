package
{
	import flash.display.MovieClip;
	import flash.errors.StackOverflowError;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import memorphic.parser.Token;
	import memorphic.parser.Tokenizer;
	import memorphic.xpath.parser.*;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
//	import mx.utils.ObjectUtil;
//	import com.adobe.crypto.MD5;

	public class QuickTest extends MovieClip
	{

		
		public function QuickTest(){
			run();
			
		}
		


		private function run():void
		{
			
		//	checkForCycles();
		//	return;
			
			var parser:XPathParser = new XPathParser();

			var s:String = "//root/../parent::node()/parent::node()/ancestor-or-self::child1[@att='2'+$xyz][(.//x/y/@foo='bar') and func(1+'xxx',2-a)]/text()"; 
			//var s:String = "foo/ bar"; 
			
			
			var t0:int = getTimer();
		/*	
		  while(parser.tokenizer.bytesAvailable()>0){
				var tok:Token = parser.tokenizer.nextToken();
				trace(tok);
			}
			parser.tokenizer.reset();
			/**/
			parser.parse(s);
			
			var t1:int = getTimer();
			trace(t1 - t0);
//			trace(ObjectUtil.toString(tree));
//			trace("test = "+ compareWithWorking(ObjectUtil.toString(tree)));


			
		}

		private function compareWithWorking(s:String):Boolean
		{
		//	trace(MD5.hash(s));
		//	return (MD5.hash(s) == "84842b87ba06568bd541dc2db6b391be");
			//85de655f8185e129d92e0a2faf6c3950
			//c9b71187f20c987747517b09f51cfdfa
			//462d9a499ead94140a14a035e1d1d4fd
			//c9b71187f20c987747517b09f51cfdfa
			return true;
		}
		
		

	}
}

import flash.errors.StackOverflowError;
import mx.utils.ArrayUtil;
	


class OverflowMeth {
	public var name:String;
	public var cycle:Array;
	
	public function setOverflow(e:StackOverflowError):void{
		var stack:String = e.getStackTrace();
		var stackItems:Array = stack.split("\n");
		
		var items:Array = [];
		var line:String;
		var mName:String;
		var match:Array;
		while(stackItems.length > 0){
			line = String(stackItems.pop());
			match = line.match(/(?:memorphic\.xpath\.parser\:\:XPathSyntaxTree\/)(.+)(?:\()/);
			if(match == null){
				continue;
			}
			mName = match[1];
			//trace(ArrayUtil.getItemIndex(mName, items));
			if(ArrayUtil.getItemIndex(mName, items) > -1){
				break;
			}
			items.push(mName);
		}
		cycle = items;//items;
	}
}