package codeghost.livecast.mobile.ui
{
	public class DefaultMediumResolution implements IResolution
	{
		public static const WIDTH:int = 320;
		public static const HEIGHT:int = 240;
		
		public function DefaultMediumResolution()
		{
		}
		
		public function width():int
		{
			return WIDTH;
		}
		
		public function height():int
		{
			return HEIGHT;
		}
	}
}