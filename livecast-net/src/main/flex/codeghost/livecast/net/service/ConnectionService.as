package codeghost.livecast.net.service
{
	import codeghost.livecast.net.media.CameraSettings;
	import codeghost.livecast.net.media.MediaManager;
	
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	public class ConnectionService extends NetConnection
	{
		private var stream:NetStream;
		private var settings:ConnectionSettings;
		public var mediaMgr:MediaManager;
		private var configureDisplay:Function;
		
		[Bindable] public var streaming:Boolean = false;
		
		public function ConnectionService(settings:ConnectionSettings, configureDisplay:Function)
		{
			super();
			
			if(!settings)
				throw new Error("ConnectionSettings cannot be null");
			
			this.mediaMgr = new MediaManager(settings);
			this.settings = settings;
			this.configureDisplay = configureDisplay;
			proxyType = "best";
			addEventListener(NetStatusEvent.NET_STATUS, connectionHandler);
		}
		
		private function connectionHandler(event:NetStatusEvent):void {
			trace(event.info.code + "::" + event.info.description);
			
			switch(event.info.code) {
				case "NetConnection.Connect.Success":
					LogManager.getInstance().log("Connected to media server");
					stream = new NetStream(this);
					stream.addEventListener(NetStatusEvent.NET_STATUS, streamHandler);
					
					if(settings.publish()) {
						LogManager.getInstance().log("Publishing stream " + settings.deviceToken());
						
						stream.attachCamera(mediaMgr.camera);
						stream.attachAudio(mediaMgr.microphone);
						stream.publish(settings.deviceToken(), settings.streamType());
						configureDisplay();
					} else {
						LogManager.getInstance().log("Playing stream " + settings.streamId());
						
						stream.play(settings.streamId());
						configureDisplay(stream);
					}
					streaming = true;
					
					break;
				case "NetConnection.Connect.Rejected":
					LogManager.getInstance().log("Connection rejected");
					if(event.info.ex!=null && event.info.ex.redirect!=null) {
						LogManager.getInstance().log("Attempting redirect to " + event.info.ex.redirect);
						var handler:ReconnectHandler = new ReconnectHandler();
						handler.addEventListener(ReconnectHandler.VALUE_CHANGED, reconnect);
						handler.url = event.info.ex.redirect;
					} else {
						shutdown();
					}
					break;
				case "NetConnection.Connect.Failed":
					LogManager.getInstance().log("Connection to media server failed, server may be unavailable");
					shutdown();
					break;
				case "NetConnection.Connect.Closed":
					LogManager.getInstance().log("Connection closed by the media server");
					if(!event.info.ex) {
						connectionStrength = "assets/connection-bad.png";
						shutdown();
					}
					break;
			}
			dispatchEvent(new Event("NetStatusEvent"));
		}
		
		private function streamHandler(event:NetStatusEvent):void {
			trace(event.info.code + "::" + event.info.description);
		}
		
		public function reconnect(event:Event):void {
			trace("Attempting redirect.");
			attach(event.target.url, this.callback);
		}
		
		public function attach(url:String=null, callback:Function=null):void {
			this.callback = callback;
			if(connected) {
				trace("Disconnecting.");
				shutdown();
				connectionStrength = "assets/empty.png";
			} else {
				trace("Attempting to connect.");
				if(statsTimer) {
					statsTimer.stop();
					if(this.callback!=null)
						callback(true);
				}
				statsTimer = new  Timer(500);
				statsTimer.addEventListener(TimerEvent.TIMER, streamStats);
				statsTimer.start();
		
				if(!url) {
					LogManager.getInstance().log("Attempting to connect to " + settings.mediaServer());
					connect(settings.mediaServer(), settings.username(), settings.password());
				} else {
					LogManager.getInstance().log("Attempting to connect to " + url + ". . .");
					connect(url, settings.username(), settings.password());
				}
			}
		}
				
		public function shutdown():void {
			trace("Closing all connections.");
			LogManager.getInstance().log("Closing all connections");
			
			streaming = false;
			
			if(statsTimer) {
				statsTimer.stop();
				if(this.callback!=null)
					callback(true);
			}
			
			if(stream)
				stream.close();
			
			close();
		}
		
		private var droppedFramesLast:int = 0;
		private var droppedFramesTotal:int = 0;
		private var connMonitor:int = 0;
		private var statsTimer:Timer;
		private var callback:Function;
		[Bindable] public var connectionStrength:String;
		private function streamStats(event:TimerEvent):void {
			if(connected && stream && stream.info) {
				if(callback!=null)
					callback();
				droppedFramesLast = stream.info.droppedFrames - droppedFramesTotal;
				droppedFramesTotal = stream.info.droppedFrames; 
				
				var camera:Camera = mediaMgr.camera;
				trace(droppedFramesTotal + " / " + droppedFramesLast + " / " + 100/camera.fps*droppedFramesLast);
				if(100/camera.fps*droppedFramesLast > 50) {
					connectionStrength = "assets/connection-bad.png";
					if(connMonitor>=3 && (100/camera.fps*droppedFramesLast > 90)) {
						/*
						* It looks like we've lost the connection to the server.
						* On Android we will have already received a NetConnection.Connect.Closed event and notified the
						* user, but iOS does not receive the event.
						* We will attempt a new connection to the server, if it results in NetConnection.Connect.Failed
						* we will close the connection and notify the user.
						*/
						var testConn:NetConnection = new NetConnection();
						testConn.addEventListener(NetStatusEvent.NET_STATUS, connectionHandler);
						testConn.call("setStreamType",null,"live");
						testConn.connect(uri);
					}
					else if(100/camera.fps*droppedFramesLast > 80) {
						connMonitor++;
					} else {
						connMonitor = 0;
					}
				} else if(100/camera.fps*droppedFramesLast > 20) {
					connectionStrength = "assets/connection-ok.png";
					connMonitor = 0;
				} else { 
					connectionStrength = "assets/connection-good.png";
					connMonitor = 0;
				}
			}
			trace('connMonitor::' + connMonitor);
		}
		
		public function setMute(muted:Boolean):void {
			if(muted) {
				trace("Muting microphone");
				mediaMgr.microphone.setSilenceLevel(100);
			} else {
				trace("Un-muting microphone");
				mediaMgr.microphone.setSilenceLevel(2);
			}
		}
		
		public function setResolution(width:int, height:int):void {
			var s:CameraSettings = settings.cameraSettings();
			mediaMgr.camera.setMode(width, height, s.fps());
		}
		
		public function replaceCamera(camera:Camera):void {
			if(stream)
				stream.attachCamera(camera);
		}
	}
}