package com.ingageco.capacitormusiccontrols;

import com.getcapacitor.JSObject;
import com.getcapacitor.NativePlugin;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;


import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.support.v4.media.MediaMetadataCompat;
import android.support.v4.media.session.MediaSessionCompat;
import android.support.v4.media.session.PlaybackStateCompat;

import android.util.Log;
import android.app.Activity;
import android.content.Context;
import android.content.IntentFilter;
import android.content.Intent;
import android.app.PendingIntent;
import android.content.ServiceConnection;
import android.content.ComponentName;
import android.app.Service;
import android.os.IBinder;
import android.os.Bundle;
import android.os.Build;
import android.R;
import android.content.BroadcastReceiver;
import android.media.AudioManager;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

@NativePlugin()
public class CapacitorMusicControls extends Plugin {

    private static final String TAG = "CapacitorMusicControls";

    private static final String TAG = "MusicControls";

	private MusicControlsBroadcastReceiver mMessageReceiver;
	private MusicControlsNotification notification;
	private MediaSessionCompat mediaSessionCompat;
	private final int notificationID=7824;
	private AudioManager mAudioManager;
	private PendingIntent mediaButtonPendingIntent;
	private boolean mediaButtonAccess=true;
	private ServiceConnection mConnection;

  	private Activity capacitorActivity;

	private MediaSessionCallback mMediaSessionCallback = new MediaSessionCallback();

    private void registerBroadcaster(MusicControlsBroadcastReceiver mMessageReceiver){
		final Context context = getContext();
		context.registerReceiver((BroadcastReceiver)mMessageReceiver, new IntentFilter("music-controls-previous"));
		context.registerReceiver((BroadcastReceiver)mMessageReceiver, new IntentFilter("music-controls-pause"));
		context.registerReceiver((BroadcastReceiver)mMessageReceiver, new IntentFilter("music-controls-play"));
		context.registerReceiver((BroadcastReceiver)mMessageReceiver, new IntentFilter("music-controls-next"));
		context.registerReceiver((BroadcastReceiver)mMessageReceiver, new IntentFilter("music-controls-media-button"));
		context.registerReceiver((BroadcastReceiver)mMessageReceiver, new IntentFilter("music-controls-destroy"));

		// Listen for headset plug/unplug
		context.registerReceiver((BroadcastReceiver)mMessageReceiver, new IntentFilter(Intent.ACTION_HEADSET_PLUG));
	}

	// Register pendingIntent for broacast
	public void registerMediaButtonEvent(){

		this.mediaSessionCompat.setMediaButtonReceiver(this.mediaButtonPendingIntent);

		/*if (this.mediaButtonAccess && android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.JELLY_BEAN_MR2){
		this.mAudioManager.registerMediaButtonEventReceiver(this.mediaButtonPendingIntent);
		}*/
	}

	public void unregisterMediaButtonEvent(){
		this.mediaSessionCompat.setMediaButtonReceiver(null);
		/*if (this.mediaButtonAccess && android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.JELLY_BEAN_MR2){
		this.mAudioManager.unregisterMediaButtonEventReceiver(this.mediaButtonPendingIntent);
		}*/
	}

	public void destroyPlayerNotification(){
		this.notification.destroy();
	}


    @PluginMethod()
    public void echo(PluginCall call) {
        String value = call.getString("value");

        JSObject ret = new JSObject();
        ret.put("value", value);
        call.success(ret);
    }
}
