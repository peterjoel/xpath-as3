package memorphic.parser
{

	/**
	 * Parses external language definitions
	 *
	 */
	public class LanguageDefinition
	{


		private var xml:XML;

		public function LanguageDefinition(xml:XML){
			this.xml = xml;
		}



		public function createTokenizer():Tokenizer{
			var tokenizer:Tokenizer = new Tokenizer();
			var production:TokenPattern;
			for each(var prodNode:XML in xml.tokenizer.production){
				if(prodNode.name() == "production"){
					production = new TokenPattern(
						prodNode.@id,
						prodNode.@pattern,
						parseXMLBoolean(prodNode.@ignoreCase),
						parseXMLBoolean(prodNode.@discard));
					tokenizer.addToken(production);
				}
			}

			return tokenizer;
		}


		private function parseXMLBoolean(value:XMLList, defaultValue:Boolean=false):Boolean{
			if(defaultValue == true){
				if(value.toString() == "false"){
					return false;
				}else{
					return true;
				}
			}else{
				if(value.toString() == "true"){
					return true;
				}else{
					return false;
				}
			}

		}

	}
}