package codeghost.livecast.mobile.ui
{
	public class DefaultLowResolution implements IResolution
	{
		public static const WIDTH:int = 160;
		public static const HEIGHT:int = 120;
		
		public function DefaultLowResolution()
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