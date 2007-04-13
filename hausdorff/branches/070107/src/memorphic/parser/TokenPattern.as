package memorphic.parser
{
	public class TokenPattern{

		public var name:String;
		public var pattern:RegExp;
		public var captureGroupIndex:int;
		public var multiMatch:Boolean;
		public var lastMatch:Array = null;
		
		public function TokenPattern(
			name:String,
			pattern:String,
			ignoreCase:Boolean=false,
			multiMatch:Boolean=false,
			captureGroupIndex:int = 0
		){

			var modifiers:String = "x";
			if(ignoreCase){
				modifiers += "i";
			}
			this.name = name;
			this.multiMatch = multiMatch;
			this.captureGroupIndex = captureGroupIndex;
			// make sure the regExp matches the start of the string, but without introducing an
			// extra capturing group
			pattern = "^(?:" + pattern +")";
			this.pattern = new RegExp(pattern, modifiers);
		}


		public function matchFromStart(test:String):String
		{
			lastMatch = test.match(pattern);
			if(lastMatch){
				return lastMatch[captureGroupIndex] as String;
			}else{
				return "";
			}
		}
		
	}
}

