package codeghost.livecast.net.service
{
	import mx.collections.ArrayList;

	public class LogManager
	{
		private static var instance:LogManager;
		private var logs:ArrayList;
		
		public function LogManager()
		{
			logs = new ArrayList();
		}
		
		public static function getInstance():LogManager {
			if(!instance)
				instance = new LogManager();
			
			return instance;
		}
		
		public function log(entry:String):void {
			logs.addItem(entry);
		}
		
		public function readAll():ArrayList {
			return logs;
		}
	}
}