package codeghost.livecast.net.media
{
	import flash.media.SoundCodec;

	public interface MicrophoneSettings
	{
		function framesPerPacket():int;
		function encodeQuality():int;
		function codec():String;
		function gain():int;
		function rate():int;
		function echoSuppression():Boolean;
		function loopBack():Boolean;
		function silenceLevel():int;
		function silenceLevelTimeout():int;
	}
}