# myCast #

myCast allows you to use your iPhone or iPad as a mobile streaming video camera. Used in conjunction with Flash Media Server or Wowza Media Server, you can stream and record video anywhere you have a 3G mobile phone reception or WiFi network connection.

Videos are streamed using the FLV media container to provide low bandwidth capabilities, ideally suited for mobile bandwidth restrictions. You have control over the host, application and stream names, you can even specifiy a username and password where you want to authenticate the source of a stream on your media server.

During live streams you maintain control over the resolution, and frames per second of the live stream, with realtime feedback provided via a simple traffic light colour coded wireless icon, allowing you to know how reliably your stream is being sent. Additionally, you can switch between front and rear cameras as well as mute the audio. All these settings are available during live streaming, leaving you with complete control.

Features

* Multi-Resolution Support (640 x 480 / 320 x 240 / 160 x 120)
* Front & Rear Camera switching where supported
* Adjust Frames Per Second
* Mute to prevent audio publish
* Publish & Play (a single handset can only publish or receive at any one time, multiple handsets, or a Flash player in a web browser will be required to view the stream without an additional handset).
* Able to accept a redirect URL in a NetConnection.Connect.Rejected event.info.ex.redirect response property to allow for use with load balanced media servers
* Tap the server connection icon to view connection logs

*Recording of a stream is managed by the media server configuration.

Notes
- This application is intended for users who already have access to a streaming media server that supports the FLV container. There is no public streaming service currently provided by the developer.
- This application is Universal, working on the iPad as well as the iPhone. However, if using the original iPad you will only be able to use it to view streams due to the lack of camera.

### What is this repository for? ###

* Create your own encoder app
This repository provides the code necessary to create your own fully functioning mobile video encoder using Flex for both iOS and Android devices.

If you're looking for the prebuilt app ready to install it is available for free on the [App Store](https://itunes.apple.com/gb/app/mycast/id532100020?mt=8) or [Google Play](https://play.google.com/store/apps/details?id=air.uk.co.codeghost.livecast&hl=en)

### License ###

* See the [LICENSE](https://bitbucket.org/codeghost/mycast/src/2c1eb27fcdaa5d573cc3994b92d6dde261d7b342/COPYING?at=master) file

### Support this project ###
If you find this project useful, please consider making a donation to help support the work.

