package codeghost.livecast.mobile.ui
{
	public class Resolution implements IResolution
	{
		private var _width:int;
		private var _height:int;
		
		public function Resolution(width:int, height:int)
		{
			_width = width;
			_height = height;
		}
		
		public function width():int
		{
			return _width;
		}
		
		public function height():int
		{
			return _height;
		}
	}
}