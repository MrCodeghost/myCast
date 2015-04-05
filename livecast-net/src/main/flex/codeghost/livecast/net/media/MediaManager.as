package codeghost.livecast.net.media
{
	import codeghost.livecast.net.service.ConnectionSettings;
	
	import flash.media.Camera;
	import flash.media.Microphone;

	public class MediaManager
	{
		public var camera:Camera;
		public var microphone:Microphone;
		
		public function MediaManager(settings:ConnectionSettings)
		{
			if(!Camera.isSupported || !Microphone.isSupported)
				throw new Error("Device not supported.");
			
			camera = initCamera(Camera.getCamera("0"), settings.cameraSettings());
			microphone = initMicrophone(Microphone.getMicrophone(), settings.microphoneSettings());
		}
		
		private function initCamera(camera:Camera, settings:CameraSettings):Camera {
			camera.setQuality(settings.bandwidth(), settings.streamQuality());
			camera.setMode(settings.width(), settings.height(), settings.fps());
			camera.setKeyFrameInterval(settings.kfi());
			
			return camera;
		}
		
		private function initMicrophone(microphone:Microphone, settings:MicrophoneSettings):Microphone {
			microphone.framesPerPacket = settings.framesPerPacket();
			microphone.encodeQuality = settings.encodeQuality();
			microphone.codec = settings.codec();
			microphone.gain = settings.gain();
			microphone.rate = settings.rate();
			microphone.setUseEchoSuppression(settings.echoSuppression());
			microphone.setLoopBack(settings.loopBack());
			microphone.setSilenceLevel(settings.silenceLevel(), settings.silenceLevelTimeout());
			
			return microphone;
		}
		
		public function switchCamera():Camera {
			var position:String;
			if(camera.position=="back") {
				trace("Switching to front camera");
				position = "front";
			} else {
				trace("Switching to rear camera");
				position = "back"
			}
			
			for (var i:uint = 0; i < Camera.names.length; ++i) { 
				var cam:Camera = Camera.getCamera(String(i)); 
				if (cam.position == position) 
					camera = cam; 
			} 
			return camera;
		}
		
	}
}