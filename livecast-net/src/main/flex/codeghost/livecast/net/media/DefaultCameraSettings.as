package codeghost.livecast.net.media
{
	public class DefaultCameraSettings implements CameraSettings
	{
		private static const WIDTH:int = 320;
		private static const HEIGHT:int = 240;
		private static const FPS:int = 15;
		private static const KFI:int = 15;
		private static const BANDWIDTH:int = 0;
		private static const STREAM_QUALITY:int = 70;
		
		public function DefaultCameraSettings()
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
		
		public function fps():int
		{
			return FPS;
		}
		
		public function kfi():int
		{
			return KFI;
		}
		
		public function bandwidth():int
		{
			return BANDWIDTH;
		}
		
		public function streamQuality():int
		{
			return STREAM_QUALITY;
		}
	}
}