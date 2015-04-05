package codeghost.livecast.net.service
{
	import codeghost.livecast.net.media.CameraSettings;
	import codeghost.livecast.net.media.MicrophoneSettings;

	public interface ConnectionSettings
	{
		function mediaServer():String;
		function repositoryURL():String;
		function deviceToken():String;
		function username():String;
		function password():String;
		function streamId():String;
		function setStreamId(streamId:String):void;
		function streamType():String;
		function cameraSettings():CameraSettings;
		function microphoneSettings():MicrophoneSettings;
		function maxFps():int;
		function minFps():int;
		function publish():Boolean;
	}
}