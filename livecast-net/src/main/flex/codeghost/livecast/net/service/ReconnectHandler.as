package codeghost.livecast.net.service
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class ReconnectHandler extends EventDispatcher
	{
		public static const VALUE_CHANGED:String = "value_changed";
		
		private var _url:String;
		
		public function ReconnectHandler(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function set url(value:String):void {
			_url = value;
			var timer:Timer = new Timer(0, 1);
			timer.addEventListener(TimerEvent.TIMER, reconnect);
			timer.start();
		}
		
		public function get url():String {
			return _url;
		}
		
		private function reconnect(event:TimerEvent):void {
			dispatchEvent(new Event(VALUE_CHANGED));
		}
		
	}
}