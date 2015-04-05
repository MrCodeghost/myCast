package codeghost.livecast.mobile.persistence
{
	import codeghost.livecast.mobile.ui.DefaultMediumResolution;
	import codeghost.livecast.mobile.ui.IResolution;
	import codeghost.livecast.mobile.ui.Resolution;
	
	import mx.states.State;
	
	import spark.managers.PersistenceManager;
	
	public class SettingsManager extends PersistenceManager
	{
		private static const DEVICE_TOKEN:String = "DEVICE_TOKEN";
		private static const MEDIA_SERVER:String = "MEDIA_SERVER";
		private static const RESOLUTION_WIDTH:String = "RESOLUTION_WIDTH";
		private static const RESOLUTION_HEIGHT:String = "RESOLUTION_HEIGHT";
		private static const FPS:String = "FPS";
		private static const MUTE:String = "MUTE";
		
		public var streamId:String;
		
		public function SettingsManager()
		{
			super();
		}
		
		public function deviceToken():String {
			if(!getProperty(DEVICE_TOKEN))
				return null;
			return String(getProperty(DEVICE_TOKEN));
		}
		
		public function saveDeviceToken(deviceToken:String):Boolean {
			setProperty(DEVICE_TOKEN, deviceToken);
			return save();
		}
		
		public function mediaServer():String {
			if(!getProperty(MEDIA_SERVER))
				return null;
			return String(getProperty(MEDIA_SERVER));
		}
		
		public function saveMediaServer(mediaServer:String):Boolean {
			setProperty(MEDIA_SERVER, mediaServer);
			return save();
		}
		
		public function resolution():IResolution {
			if(!getProperty(RESOLUTION_WIDTH) || !getProperty(RESOLUTION_HEIGHT))
				return new DefaultMediumResolution();
			return new Resolution(int(getProperty(RESOLUTION_WIDTH)), int(getProperty(RESOLUTION_HEIGHT)));
		}
		
		public function saveResolution(resolution:IResolution):Boolean {
			setProperty(RESOLUTION_WIDTH, resolution.width());
			setProperty(RESOLUTION_HEIGHT, resolution.height());
			return save();
		}
		
		public function fps():int {
			if(!getProperty(FPS))
				return -1;
			return int(getProperty(FPS));
		}
		
		public function saveFps(fps:int):Boolean {
			setProperty(FPS, fps);
			return save();
		}
		
		public function mute():Boolean {
			if(!getProperty(MUTE))
				return false;
			return Boolean(getProperty(MUTE));
		}
		
		public function saveMute(mute:Boolean):Boolean {
			setProperty(MUTE, mute);
			return save();
		}
	}
}