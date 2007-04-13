package scratch
{
	public class TestThing
	{

		public function getUtil():InternalUtil{
			return new InternalUtil();
		}
	}
}


class InternalUtil {
	internal var blah:Boolean = false;
}