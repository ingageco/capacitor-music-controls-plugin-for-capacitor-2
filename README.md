# Capacitor Music Controls Plugin

An update to Cordova Music Controls plugin to support Capacitor 2 (Capacitor 3 not supported in this repo)

Music controls for Capacitor applications. Display a 'media' notification with play/pause, previous, next buttons, allowing the user to control the play. Handles headset events (plug, unplug, headset button) on Android.

This plugin is forked from the original Cordova plugin which is no longer maintained but which can be found at:
https://github.com/homerours/cordova-music-controls-plugin

##  work in progress

this integration is a work in progress. currently, most controls work as expected. there are some questions around supplying images on iOS.

PRs for rounding out issues and improving the plugin are welcome.

## Supported platforms

- Android
- iOS

## Installation

- Current release
`npm install capacitor-music-controls-plugin`

## iOS

Run:
npx cap sync ios

## Android (thanks @lbesiche)

After you install the plugin, locate your MainActivity.java (can be found in /android/app/src/main/java/path/to/my/app/MainActivity.java)

import this path:
import com.ingageco.capacitormusiccontrols.CapacitorMusicControls;

add class inside bridge activity:
add(CapacitorMusicControls.class);

Finally, run:
npx cap sync android


## Importing the Plugin

At the top of your file import Capacitor Plugins and this extract this plugin

```javascript
import { Plugins } from '@capacitor/core';
const { CapacitorMusicControls } = Plugins;
```

## Methods

- Create the media controls:
```javascript
CapacitorMusicControls.create({
	track       : 'Time is Running Out',		// optional, default : ''
	artist      : 'Muse',						// optional, default : ''
	album       : 'Absolution',     // optional, default: ''
 	cover       : 'albums/absolution.jpg',		// optional, default : nothing
	// cover can be a local path (use fullpath 'file:///storage/emulated/...', or only 'my_image.jpg' if my_image.jpg is in the www folder of your app)
	//			 or a remote url ('http://...', 'https://...', 'ftp://...')

	// hide previous/next/close buttons:
	hasPrev   : false,		// show previous button, optional, default: true
	hasNext   : false,		// show next button, optional, default: true
	hasClose  : true,		// show close button, optional, default: false

	// iOS only, optional
	duration : 60, // optional, default: 0
	elapsed : 10, // optional, default: 0
  	hasSkipForward : true, //optional, default: false. true value overrides hasNext.
  	hasSkipBackward : true, //optional, default: false. true value overrides hasPrev.
  	skipForwardInterval : 15, //optional. default: 15.
	skipBackwardInterval : 15, //optional. default: 15.
	hasScrubbing : false, //optional. default to false. Enable scrubbing from control center progress bar 

    // Android only, optional
    isPlaying   : true,							// optional, default : true
    dismissable : true,							// optional, default : false
	// text displayed in the status bar when the notification (and the ticker) are updated
	ticker	  : 'Now playing "Time is Running Out"',
	//All icons default to their built-in android equivalents
	//The supplied drawable name, e.g. 'media_play', is the name of a drawable found under android/res/drawable* folders
	playIcon: 'media_play',
	pauseIcon: 'media_pause',
	prevIcon: 'media_prev',
	nextIcon: 'media_next',
	closeIcon: 'media_close',
	notificationIcon: 'notification'
}, onSuccess, onError);
```

- Update whether the music is playing true/false, as well as the time elapsed (seconds)

```javascript
CapacitorMusicControls.updateIsPlaying({
    isPlaying: true, // affects Android only
    elapsed: timeElapsed // affects iOS Only
});
```

- Listen for events and pass them to your handler function

```javascript
CapacitorMusicControls.addListener('controlsNotification', (info: any) => {
    console.log('controlsNotification was fired');
    console.log(info);
    handleControlsEvent(info);
});
```



- Example event handler

```javascript
handleControlsEvent(action){

	console.log("hello from handleControlsEvent")
	const message = action.message;

	console.log("message: " + message)

	switch(message) {
		case 'music-controls-next':
			// next
			break;
		case 'music-controls-previous':
			// previous
			break;
		case 'music-controls-pause':
			// paused
			break;
		case 'music-controls-play':
			// resumed
			break;
		case 'music-controls-destroy':
			// controls were destroyed
			break;

		// External controls (iOS only)
		case 'music-controls-toggle-play-pause' :
			// do something
			break;
		case 'music-controls-seek-to':
			// do something
			break;
		case 'music-controls-skip-forward':
			// Do something
			break;
		case 'music-controls-skip-backward':
			// Do something
			break;

		// Headset events (Android only)
		// All media button events are listed below
		case 'music-controls-media-button' :
			// Do something
			break;
		case 'music-controls-headset-unplugged':
			// Do something
			break;
		case 'music-controls-headset-plugged':
			// Do something
			break;
		default:
			break;
	}
}
```

## credits & contributions

Original plugin by:
homerours (https://github.com/homerours)

Documentation influenced by:
ghenry22 (https://github.com/ghenry22)
ghenry22 successor to Cordova Music Controls (https://github.com/ghenry22/cordova-plugin-music-controls2/)

Special thanks to some forks with changes: 
trabdin (https://github.com/trabdin)
