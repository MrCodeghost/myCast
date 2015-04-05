package codeghost.livecast.mycast
{
	import codeghost.livecast.mobile.persistence.SettingsManager;
	import codeghost.livecast.net.media.CameraSettings;
	import codeghost.livecast.net.media.DefaultCameraSettings;
	import codeghost.livecast.net.media.DefaultMicrophoneSettings;
	import codeghost.livecast.net.media.MicrophoneSettings;
	import codeghost.livecast.net.service.ConnectionSettings;
	
	public class MyCastConnectionSettings implements ConnectionSettings
	{
		private static const STREAM_TYPE:String = "live-record";
		private static const DEFAULT_FPS:int = 15;
		private static const MAX_FPS:int = 20;
		private static const MIN_FPS:int = 5;
		
		private var settingsMgr:SettingsManager;
		private var securitasCameraSettings:CameraSettings;
		private var securitasMicrophoneSettings:MicrophoneSettings;
		
		public function MyCastConnectionSettings(settingsMgr:SettingsManager)
		{
			this.settingsMgr = settingsMgr;
			if(settingsMgr.fps()==-1)
				settingsMgr.saveFps(DEFAULT_FPS);
			securitasCameraSettings = new DefaultCameraSettings();
			securitasMicrophoneSettings = new DefaultMicrophoneSettings();
		}
		
		public function mediaServer():String
		{
			return settingsMgr.getProperty("settings.host") + settingsMgr.getProperty("settings.app");
		}
		
		public function repositoryURL():String
		{
			return String(settingsMgr.getProperty("settings.host")==null?"":settingsMgr.getProperty("settings.host"));
		}
		
		public function app():String
		{
			return String(settingsMgr.getProperty("settings.app")==null?"":settingsMgr.getProperty("settings.app"));
		}
		
		public function deviceToken():String
		{
			return String(settingsMgr.getProperty("settings.stream")==null?"":settingsMgr.getProperty("settings.stream"));
		}
		
		public function streamId():String
		{
			return String(settingsMgr.getProperty("settings.stream")==null?"":settingsMgr.getProperty("settings.stream"));
		}
		
		public function setStreamId(streamId:String):void
		{
			settingsMgr.setProperty("settings.stream", streamId);
		}
		
		public function streamType():String
		{
			return STREAM_TYPE;
		}
		
		public function cameraSettings():CameraSettings
		{
			return securitasCameraSettings;
		}
		
		public function microphoneSettings():MicrophoneSettings
		{
			return securitasMicrophoneSettings;
		}
		
		public function maxFps():int {
			return MAX_FPS;
		}
		
		public function minFps():int {
			return MIN_FPS;
		}
		
		public function username():String {
			return String(settingsMgr.getProperty("settings.username")==null?"":settingsMgr.getProperty("settings.username"));
		}
		
		public function password():String {
			return String(settingsMgr.getProperty("settings.password")==null?"":settingsMgr.getProperty("settings.password"));
		}
		
		public function publish():Boolean {
			if(settingsMgr.getProperty("settings.publish")!=null) {
				return true;
			} else {
				return false;
			}
		}
	}
}