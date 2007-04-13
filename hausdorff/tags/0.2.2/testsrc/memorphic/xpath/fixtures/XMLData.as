package memorphic.xpath.fixtures
{
	import flash.utils.ByteArray;

	public class XMLData
	{


		public static function get adobeBlogsRDF():XML{
			return XPATH_FLASH_RDF.copy();
		}

		public static function get adobeHomeXHTML():XML{
			return ADOBE_HOME.copy();
		}

		public static function get foodMenuXML():XML{
			return MENU.copy();
		}

		public static function get cdCatalogXML():XML{
			return CD_CAT.copy();
		}


		[Embed(source="flash_xpath.rdf", mimeType="application/octet-stream")]
		private static const XPATH_FLASH_RDF_RAW:Class;
		private static const XPATH_FLASH_RDF:XML = parseXML(new XPATH_FLASH_RDF_RAW());

		[Embed(source="adobe.xhtml", mimeType="application/octet-stream")]
		private static const ADOBE_HOME_RAW:Class;
		private static const ADOBE_HOME:XML = parseXML(new ADOBE_HOME_RAW());

		[Embed(source="cd_catalog.xml", mimeType="application/octet-stream")]
		private static const CD_CAT_RAW:Class;
		private static const CD_CAT:XML = parseXML(new CD_CAT_RAW());

		[Embed(source="menu.xml", mimeType="application/octet-stream")]
		private static const MENU_RAW:Class;
		private static const MENU:XML = parseXML(new MENU_RAW());



		private static function parseXML(data:ByteArray):XML{
			return new XML(data.readUTFBytes(data.length));
		}


	}

}