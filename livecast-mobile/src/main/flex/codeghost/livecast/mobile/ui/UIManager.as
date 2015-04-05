package codeghost.livecast.mobile.ui
{
	import codeghost.livecast.mobile.persistence.SettingsManager;
	import codeghost.livecast.net.service.ConnectionService;
	import codeghost.livecast.net.service.ConnectionSettings;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.KeyboardEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Timer;
	
	import mx.binding.utils.BindingUtils;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.states.State;
	
	import org.osmf.events.TimeEvent;

	public class UIManager 
	{
		private var settingsMgr:SettingsManager;
		[Bindable] public var connectionSvc:ConnectionService;
		private var connectionSettings:ConnectionSettings;

		private var display:Video;
		public var videoContainer:UIComponent;
		
		public var launchDeviceId:String;
		public var launchMediaServer:String;
		
		[Bindable] public var lowResAlpha:Number=0.5;
		[Bindable] public var medResAlpha:Number=0.5;
		[Bindable] public var higResAlpha:Number=0.5;
		[Bindable] public var recordButtonAlpha:Number=0.5;
		
		[Bindable] public var fps:int;
		[Bindable] public var increaseFpsEnabled:Boolean=true;
		[Bindable] public var decreaseFpsEnabled:Boolean=true;
		[Bindable] public var muted:Boolean;
		
		private var recording:Boolean = false;
		
		public function UIManager(connectionSettings:ConnectionSettings)
		{
			settingsMgr = new SettingsManager();
			connectionSvc = new ConnectionService(connectionSettings, configureDisplay);
			this.connectionSettings = connectionSettings;
			
			fps = settingsMgr.fps();
			if(fps>=connectionSettings.maxFps())
				increaseFpsEnabled = false;
			if(fps<=connectionSettings.minFps())
				decreaseFpsEnabled = false;
			setFps(fps);
			
			muted = settingsMgr.mute();
			connectionSvc.setMute(muted);
			
			var resolution:IResolution = settingsMgr.resolution();
			setResolution(new Resolution(resolution.width(), resolution.height()));
			switch(resolution.width())
			{
				case DefaultLowResolution.WIDTH:
					lowResAlpha = 1.0;
					break;
				case DefaultHighResolution.WIDTH:
					higResAlpha = 1.0;
					break;
				default:
					medResAlpha = 1.0;
					break;
			}
			
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
		}
	
		public function preinit(event:FlexEvent):void {
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, invokeHandler);
			if(Capabilities.cpuArchitecture=="ARM") {
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate, false, 0, true);
				NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys, false, 0, true);
			}
			
			if(Capabilities.os.indexOf("iPhone")>=0 && Capabilities.os.indexOf("iPad")<0) {
				display = new Video(Capabilities.screenResolutionY/Capabilities.screenDPI*160 + 10, Capabilities.screenResolutionX/Capabilities.screenDPI*160 + 10);
			} else if(Capabilities.os.indexOf("iPad")>=0) {
				display = new Video(Capabilities.screenResolutionY, Capabilities.screenResolutionX);
			} else {
				display = new Video(Capabilities.screenResolutionX/Capabilities.screenDPI*160 + 10, Capabilities.screenResolutionY/Capabilities.screenDPI*160 + 10);
			}
			
			display.smoothing = true;
			
			videoContainer = new UIComponent();
			videoContainer.addChild(display);
		}
		
		public function configureDisplay(stream:NetStream=null):void {
			if(stream) {
				display.attachNetStream(stream);
			} else {
				display.attachCamera(connectionSvc.mediaMgr.camera);
			}
		}
		
		private function invokeHandler(event:InvokeEvent):void {
			trace(event.arguments);
			if(event.arguments[0]!=null) {
				var args:Array = event.arguments[0].split("&");
				if(args.length==1) {
					connectionSettings.setStreamId(args[0].substr(args[0].indexOf("//")+2));
					setup();
					connectionSvc.attach();
				} 
			}
		}
		
		private function handleDeactivate(event:Event):void
		{
			if(connectionSvc)
				connectionSvc.shutdown();
			
			NativeApplication.nativeApplication.exit();
		}
		
		private function handleKeys(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.BACK && connectionSvc) 
				connectionSvc.shutdown();

			NativeApplication.nativeApplication.exit();
		}
		
		public function setup():String {
			if(!launchDeviceId) {
				if(!settingsMgr.deviceToken()) {
					return "unknownUser";
				} else {
					if(connectionSettings.streamId()) {
						return "streaming";
					} else {
						configureDisplay();
						return "default";
					}
				}
			} else {
				if(settingsMgr.deviceToken()) {
					return "replaceUser";
				} else {
					settingsMgr.saveDeviceToken(launchDeviceId);
					settingsMgr.saveMediaServer(launchMediaServer);
					
					configureDisplay();
					return "default";
				}
			}
		}
		
		public function increaseFps(event:TouchEvent):void
		{
			trace("Increase FPS tapped");
			
			fps+=5;
			settingsMgr.saveFps(fps);
			
			if(fps>=connectionSettings.maxFps())
				increaseFpsEnabled = false;
			
			decreaseFpsEnabled = true;
			setFps(fps);
		}
		
		public function decreaseFps(event:TouchEvent):void
		{
			trace("Decrease FPS tapped");
			
			fps-=5;
			settingsMgr.saveFps(fps);
			
			if(fps<=connectionSettings.minFps())
				decreaseFpsEnabled = false;
			
			increaseFpsEnabled = true;
			setFps(fps);
		}
		
		public function toggleMute(event:TouchEvent):void 
		{
			trace("Mute Tapped");

			muted = !muted;
			connectionSvc.setMute(muted);
			settingsMgr.saveMute(muted);
		}
		
		public function resolutionHandler(event:TouchEvent):void {
			lowResAlpha = 0.5;
			medResAlpha = 0.5;
			higResAlpha = 0.5;
			
			switch(event.currentTarget.id)
			{
				case "lowRes":
					trace("Setting low res");
					lowResAlpha = 1.0;
					settingsMgr.saveResolution(new DefaultLowResolution());
					break;
				case "mediumRes":
					trace("Setting medium res");
					medResAlpha = 1.0;
					settingsMgr.saveResolution(new DefaultMediumResolution());
					break;
				case "highRes":
					trace("Setting high res");
					higResAlpha = 1.0;
					settingsMgr.saveResolution(new DefaultHighResolution());
					break;
			}
			
			setResolution(settingsMgr.resolution());
		}
		
		private function setResolution(resolution:IResolution):void {
			trace(resolution.width() + "/" + resolution.height() + "/" + fps);
			connectionSvc.mediaMgr.camera.setMode(resolution.width(), resolution.height(), fps);
			connectionSvc.mediaMgr.camera.setQuality(0, 70);
		}
		
		private function setFps(fps:int):void {
			var resolution:IResolution = settingsMgr.resolution();
			this.fps = fps;
			settingsMgr.saveFps(fps);
			setResolution(resolution);
		}

		public function recordHandler(event:TouchEvent):void {
			trace("Toggle recording");
			connectionSvc.attach(null, flashRecordButton);
		}
		
		public function flashRecordButton(stop:Boolean=false):void {
			if(!stop) {
				recordButtonAlpha==1.0?recordButtonAlpha=0.5:recordButtonAlpha=1.0;
			} else {
				recordButtonAlpha=0.5;
			}
		}
		
		public function switchCamera(event:TouchEvent):void {
			trace("Switch Camera");
			var camera:Camera = connectionSvc.mediaMgr.switchCamera();
			setResolution(settingsMgr.resolution());
			display.attachCamera(camera);
			connectionSvc.replaceCamera(camera);
		}
		
		public function setDeviceId(deviceId:String):void {
			trace("Setting Device ID");
			settingsMgr.saveDeviceToken(deviceId);
		}

	}
}