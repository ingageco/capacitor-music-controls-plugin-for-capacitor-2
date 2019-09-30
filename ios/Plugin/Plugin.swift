import Foundation
import Capacitor

import MediaPlayer;

extension DispatchQueue {

     static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
         DispatchQueue.global(qos: .background).async {
             background?()
             if let completion = completion {
                 DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                     completion()
                 })
             }
         }
     }

 }

 
/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(CapacitorMusicControls)
public class CapacitorMusicControls: CAPPlugin {
    
    var musicControlsInfo: CapacitorMusicControlsInfo!;
    var latestEventCallbackId: Any?;
 
    @objc func create(_ call: CAPPluginCall) {
        let options: Dictionary = call.options;
        
        
        print("MusicControlsOptions:")
        for optionLine in options {
          print(optionLine)
        }
        
        
        
        self.musicControlsInfo = CapacitorMusicControlsInfo(dictionary: options as NSDictionary);
      
        print("initial npi:")
       print(self.musicControlsInfo)
 
        self.registerMusicControlsEventListener();

        // DispatchQueue.background(delay: 5.0, background: {
        
 
            var nowPlayingInfo = [String: Any]()
        
   

        
           // let mediaItemArtwork = self.createCoverArtwork(coverUri: self.musicControlsInfo.cover!);
            let duration = self.musicControlsInfo.duration;
            let elapsed = self.musicControlsInfo.elapsed;
            let playbackRate = self.musicControlsInfo.isPlaying;
            
 
 
//            if(mediaItemArtwork != nil){
//                nowPlayingInfo?[MPMediaItemPropertyArtwork] = mediaItemArtwork;
//            }
            
//            nowPlayingInfo[MPMediaItemPropertyArtist] = "Hello world";
//            nowPlayingInfo[MPMediaItemPropertyTitle] = "Track Name";
//            nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = "The Gate Church";
//            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration;
//            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsed;
//            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = playbackRate;
            
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [
                MPMediaItemPropertyArtist: self.musicControlsInfo.artist,
                MPMediaItemPropertyTitle:self.musicControlsInfo.track,
                MPMediaItemPropertyAlbumTitle:self.musicControlsInfo.album,
                MPMediaItemPropertyPlaybackDuration:duration,
                MPNowPlayingInfoPropertyElapsedPlaybackTime:elapsed,
                MPNowPlayingInfoPropertyPlaybackRate:playbackRate
            ]
            
            
             MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            print("Now playing local: \(nowPlayingInfo)")

            print("Now playing lock screen: \(MPNowPlayingInfoCenter.default().nowPlayingInfo)")
//
//        }, completion:{
//            // when background job finished, do something in main thread
//
//
//        })
        
        

        
        

        
        
        
       call.success();
        
    }
    
    
    @objc func updateIsPlaying(_ call: CAPPluginCall) {
        
        let options: Dictionary = call.options;
 
        print("MusicControlsOptions:")
        for optionLine in options {
          print(optionLine)
        }
        
        musicControlsInfo = CapacitorMusicControlsInfo(dictionary: options as NSDictionary);
        
        let elapsed = self.musicControlsInfo.elapsed;
        let playbackRate = self.musicControlsInfo.isPlaying;
        

        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default();
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo;
 
 
        nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsed;
        nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = playbackRate;
        
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo

        call.success();

    }
    
    @objc func updateElapsed(_ call: CAPPluginCall) {
       
        self.updateIsPlaying(call);
        
           
    }
    
    @objc func destroy(_ call: CAPPluginCall) {
        self.deregisterMusicControlsEventListener();
        
        call.success();
           
    }
    
    @objc func watch(_ call: CAPPluginCall) {

        self.latestEventCallbackId = call.callbackId;
    }
    
    
    func createCoverArtwork(coverUri : String) -> MPMediaItemArtwork? {
        
        var coverImage: UIImage?;
        
        if (coverUri.hasPrefix("http://") || coverUri.hasPrefix("https://")) {
            print("Cover item is a URL");

            let coverImageUrl = URL(string: coverUri)!;
            
            do{

                let coverImageData = try Data(contentsOf: coverImageUrl);
                coverImage = UIImage(data:coverImageData)!;
 
            } catch {
                print("Could not make image");
            }
        }
        else if (coverUri.hasPrefix("file://")) {

            
            let fullCoverImagePath = coverUri.replacingOccurrences(of: "file://", with: "");
            
            let defaultManager = FileManager.default;
            
            if(defaultManager.fileExists(atPath: fullCoverImagePath)){
                coverImage = UIImage(contentsOfFile: fullCoverImagePath)!
            }
 
        }
        else if (coverUri != "") {
            
            let baseCoverImagePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
            let fullCoverImagePath = String(format:"%@%@", baseCoverImagePath, coverUri);
            
            let defaultManager = FileManager.default;
            
            if(defaultManager.fileExists(atPath: fullCoverImagePath)){
                coverImage = UIImage(contentsOfFile: fullCoverImagePath)!
            }

        }
        else {
            coverImage = UIImage(named: "none")!;
        }
        
        if(self.isCoverImageValid(inputImage: coverImage!)){
            // return MPMediaItemArtwork.image(coverImage);
            return MPMediaItemArtwork.init(boundsSize: coverImage!.size, requestHandler: { (size) -> UIImage in
                    return coverImage!
            })
        } else {
            return nil;
        }
        
       //  return [self isCoverImageValid:coverImage] ? [[MPMediaItemArtwork alloc] initWithImage:coverImage] : nil;
        
    }
    
    func isCoverImageValid(inputImage: UIImage) -> Bool {
        
        let cii = CIImage(image: inputImage);
        // let cgi = self.convertCIImageToCGImage(inputImage: cii!);
        
        return inputImage != nil && cii != nil;

    }
    
//    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage! {
//        let context = CIContext(options: nil)
//        if context != nil {
//            return context.createCGImage(inputImage, fromRect: inputImage.extent())
//        }
//        return nil
//    }
    
    @objc func changedThumbSliderOnLockScreen(_ event: MPChangePlaybackPositionCommandEvent) -> MPRemoteCommandHandlerStatus {
        print("changePlaybackPositionCommand");

        self.notifyListeners("controlsNotification", data: [ "message" : "music-controls-skip-to", "position" : event.positionTime ])

        
        return .success;
    }
    
    @objc func skipForwardEvent(_ event: MPSkipIntervalCommandEvent){
        self.notifyListeners("controlsNotification", data: [ "message" : "music-controls-skip-forward" ])

        
    }
    
    @objc func skipBackwardEvent(_ event: MPSkipIntervalCommandEvent){
        self.notifyListeners("controlsNotification", data: [ "message" : "music-controls-skip-backward" ])

    }
    
    @objc func remoteEvent(_ event: MPRemoteCommandEvent){
        return;
    }
    
    @objc func nextTrackEvent(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        print("hello from nextTrackEvent");
           self.notifyListeners("controlsNotification", data: [ "message" : "music-controls-next" ])
        return .success;

       }
    
    @objc func prevTrackEvent(_ event: MPRemoteCommandEvent){
           self.notifyListeners("controlsNotification", data: [ "message" : "music-controls-previous" ])

    }
    
    @objc func pauseEvent(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
           self.notifyListeners("controlsNotification", data: [ "message" : "music-controls-pause" ])
        return .success

    }
    
   @objc func playEvent(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
       self.notifyListeners("controlsNotification", data: [ "message" : "music-controls-play" ])
        return .success

    }
    
    @objc func handleMusicControlsNotification(_ notification: NSNotification){
        
        
        let receivedEvent: UIEvent = notification.object as! UIEvent;
        
        if (self.latestEventCallbackId == nil) {
            return;
        }
        
        if (receivedEvent.type == .remoteControl) {
 
            var action:String?;
            
            print("receivedEvent:");
            print(receivedEvent.subtype);
            
            switch (receivedEvent.subtype) {
                case .remoteControlTogglePlayPause:
                    action = "music-controls-toggle-play-pause";
                    break;
                    
                case .remoteControlPlay:
                    action = "music-controls-play";
                    break;
                    
                case .remoteControlPause:
                    action = "music-controls-pause";
                    break;
                    
            case .remoteControlPreviousTrack:
                    action = "music-controls-previous";
                    break;
                    
            case .remoteControlNextTrack:
                    action = "music-controls-next";
                    break;
                    
            case .remoteControlStop:
                    action = "music-controls-destroy";
                    break;
                    
                default:
                    action = nil;
                    break;
            }
            
            if(action == nil){
                return;
            }
            
            // var jsonAction = String(format:"{\"message\":\"%@\"}", action!);
            
            // NSString * jsonAction = [NSString stringWithFormat:@"{\"message\":\"%@\"}", action];
//            CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jsonAction];
//            [self.commandDelegate sendPluginResult:pluginResult callbackId:[self latestEventCallbackId]];
//
            
            
            self.notifyListeners("controlsNotification", data: [ "message" : action ])


         
        }
        
    }
    
    func registerMusicControlsEventListener(){
        
       DispatchQueue.main.async { // Correct

            UIApplication.shared.beginReceivingRemoteControlEvents();
        
        
        }
            
            print("hello from registering");

            NotificationCenter.default.addObserver(self, selector: #selector(self.handleMusicControlsNotification(_:)), name: NSNotification.Name(rawValue: "musicControlsEventNotification"), object: nil)
        
        let commandCenter = MPRemoteCommandCenter.shared();

        commandCenter.playCommand.isEnabled = true;
            // commandCenter.playCommand.addTarget(self, action: #selector(self.playEvent(_:)));
            commandCenter.playCommand.addTarget { [unowned self] event in
                     
                print("playCommand");
                self.notifyListeners("controlsNotification", data: [ "message" : "music-controls-play" ])

                      return .success
                 
              }
            
            
        commandCenter.pauseCommand.isEnabled = true;
       //     commandCenter.playCommand.addTarget(self, action: #selector(self.pauseEvent(_:)));
            commandCenter.pauseCommand.addTarget { [unowned self] event in
                   
                print("pauseCommand");

                self.notifyListeners("controlsNotification", data: [ "message" : "music-controls-pause" ])

                    return .success
               
            }
            
            print("integrity");
            print(self.musicControlsInfo.hasNext);
           if(self.musicControlsInfo.hasNext!){
                commandCenter.nextTrackCommand.isEnabled = true;
               commandCenter.nextTrackCommand.addTarget(self, action: #selector(CapacitorMusicControls.nextTrackEvent(_:)));
            }
//
            if(self.musicControlsInfo.hasPrev!){
            commandCenter.previousTrackCommand.isEnabled = true;
//                commandCenter.previousTrackCommand.addTarget(self, action: #selector(self.prevTrackEvent(_:)));

            commandCenter.previousTrackCommand.addTarget { [unowned self] event in

                           print("previousTrackCommand");

                           self.notifyListeners("controlsNotification", data: [ "message" : "music-controls-previous" ])

                               return .success

                       }
            }
//
         if(floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_0){

            if(self.musicControlsInfo.hasSkipForward!){
                commandCenter.skipForwardCommand.preferredIntervals = [self.musicControlsInfo.skipForwardInterval!];
                commandCenter.skipForwardCommand.isEnabled = true;
               // commandCenter.skipForwardCommand.addTarget(self, action: #selector(self.skipForwardEvent(_:)));
                commandCenter.skipForwardCommand.addTarget { [unowned self] event in

                      print("skipForwardCommand");

                      self.notifyListeners("controlsNotification", data: [ "message" : "music-controls-skip-forward" ])

                          return .success

                  }
            }
            if(self.musicControlsInfo.hasSkipBackward!){
                commandCenter.skipBackwardCommand.preferredIntervals = [self.musicControlsInfo.skipBackwardInterval!];
                commandCenter.skipBackwardCommand.isEnabled = true;
               // commandCenter.skipBackwardCommand.addTarget(self, action: #selector(self.skipBackwardEvent(_:)));
                commandCenter.skipBackwardCommand.addTarget { [unowned self] event in

                     print("skipBackwardCommand");

                     self.notifyListeners("controlsNotification", data: [ "message" : "music-controls-skip-backward" ])

                         return .success

                 }
            }
//            if(self.musicControlsInfo.hasScrubbing!){
//                commandCenter.changePlaybackPositionCommand.isEnabled = true;
//                commandCenter.changePlaybackPositionCommand.addTarget(self, action: #selector(self.changedThumbSliderOnLockScreen(_:)));
//                commandCenter.changePlaybackPositionCommand.addTarget { [unowned self] event in
//
//                    print("changePlaybackPositionCommand");
//
//                    self.notifyListeners("controlsNotification", data: [ "message" : "music-controls-skip-to", "position" : event.positionTime ])
//
//                        return .success
//
//                }
//            }

        }
 

        
    }
    
    func deregisterMusicControlsEventListener(){
        
        DispatchQueue.main.async { // Correct

        
            UIApplication.shared.endReceivingRemoteControlEvents();
        
 }

            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "receivedEvent"), object: nil)

            
          
            let commandCenter = MPRemoteCommandCenter.shared();
            
            commandCenter.nextTrackCommand.removeTarget(self);
            commandCenter.previousTrackCommand.removeTarget(self);


            
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_0) {
                commandCenter.changePlaybackPositionCommand.isEnabled = false;
                commandCenter.changePlaybackPositionCommand.removeTarget(self);
                commandCenter.skipForwardCommand.removeTarget(self);
                commandCenter.skipBackwardCommand.removeTarget(self);
            }
            
            self.latestEventCallbackId = nil;
            

        
    }
    
    deinit {
        self.deregisterMusicControlsEventListener();
    }
    
}
