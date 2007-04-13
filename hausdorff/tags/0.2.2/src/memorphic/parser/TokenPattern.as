package memorphic.parser
{
	public class TokenPattern
	{


		/**
		 * A name by which this pattern may be referred to. This name will be assigned to tokens that match this 
		 * pattern for use by the Syntax tree and parser
		 */
		public var name:String;
		
		internal var matchFromStartPattern:RegExp;
		
		
		/**
		* [Not implemented]
		*/		
		public var captureGroupIndex:int;
		
		/**
		* [Not implemented]
		*/		
		public var multiMatch:Boolean;
		
		/**
		 *  The result of the previous time that <code>matchFromStart()</code> was executed
		 */
		public var lastMatch:Array = null;
		
		
		/**
		 * 
		 * @param name A name to assign to this pattern. This should be unique within the lexer and grammar
		 * @param pattern A string that will be converted into a regular expression which will match the token
		 * @param ignoreCase Determines if the regular expression will have its ignoreCase flag set
		 * @param multiMatch [Not implemented]
		 * @param captureGroupIndex [Not implemented]
		 * 
		 */		
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
			matchFromStartPattern = new RegExp("^(?:" + pattern +")", modifiers);
		}


		/**
		 * 
		 */
		public function matchFromStart(test:String):String
		{
			lastMatch = test.match(matchFromStartPattern);
			if(lastMatch){
				return lastMatch[captureGroupIndex] as String;
			}else{
				return "";
			}
		}
		
	}
}

