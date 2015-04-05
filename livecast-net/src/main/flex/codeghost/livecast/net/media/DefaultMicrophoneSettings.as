package codeghost.livecast.net.media
{
	import flash.media.SoundCodec;

	public class DefaultMicrophoneSettings implements MicrophoneSettings
	{
		private static const FRAMES_PER_PACKET:int = 5;
		private static const ENCODE_QUALITY:int = 3;
		private static const CODEC:String = SoundCodec.SPEEX;
		private static const GAIN:int = 60;
		private static const RATE:int = 11;
		private static const ECHO_SUPPRESSION:Boolean = true;
		private static const LOOP_BACK:Boolean = false;
		private static const SILENCE_LEVEL:int = 2;
		private static const SILENCE_LEVEL_TIMEOUT:int = 500;
		
		public function DefaultMicrophoneSettings()
		{
		}
		
		public function framesPerPacket():int
		{
			return FRAMES_PER_PACKET;
		}
		
		public function encodeQuality():int
		{
			return ENCODE_QUALITY;
		}
		
		public function codec():String
		{
			return CODEC;
		}
		
		public function gain():int
		{
			return GAIN;
		}
		
		public function rate():int
		{
			return RATE;
		}
		
		public function echoSuppression():Boolean
		{
			return ECHO_SUPPRESSION;
		}
		
		public function loopBack():Boolean
		{
			return LOOP_BACK;
		}
		
		public function silenceLevel():int
		{
			return SILENCE_LEVEL;
		}
		
		public function silenceLevelTimeout():int
		{
			return SILENCE_LEVEL_TIMEOUT;
		}
	}
}