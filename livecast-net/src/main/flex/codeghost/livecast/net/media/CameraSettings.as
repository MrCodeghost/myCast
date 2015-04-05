package codeghost.livecast.net.media
{
	public interface CameraSettings
	{
		function width():int;
		function height():int;
		function fps():int;
		function kfi():int;
		function bandwidth():int;
		function streamQuality():int;
	}
}