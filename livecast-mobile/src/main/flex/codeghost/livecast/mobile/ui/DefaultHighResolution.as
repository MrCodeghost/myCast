package codeghost.livecast.mobile.ui
{
	public class DefaultHighResolution implements IResolution
	{
		public static const WIDTH:int = 640;
		public static const HEIGHT:int = 480;
		
		public function DefaultHighResolution()
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