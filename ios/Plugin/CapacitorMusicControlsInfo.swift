
import Foundation

 

//@objc(CapacitorMusicControlsInfo)
public class CapacitorMusicControlsInfo: NSObject {
    

    var artist: String? = "";
    var track: String? = "";
    var album: String? = "";
    var ticker: String? = "";
    var cover: String? = nil;
    var duration: Int? = 0;
    var elapsed: Int? = 0;
    var isPlaying: Bool? = true;
    var hasPrev: Bool? = true;
    var hasNext: Bool? = true;
    var hasSkipForward: Bool? = false;
    var hasSkipBackward: Bool? = false;
    var hasScrubbing: Bool? = false;
    var skipForwardInterval: NSNumber? = 0;
    var skipBackwardInterval: NSNumber? = 0;
    var dismissable: Bool? = true;
    
    
    
    init(dictionary: NSDictionary){
        
        self.artist = dictionary["artist"] as? String;
        self.track = dictionary["track"] as? String;
        self.album = dictionary["album"] as? String;
        self.ticker = dictionary["ticker"] as? String;
        self.cover = dictionary["cover"] as? String;
        self.duration = dictionary["duration"] as? Int;
        self.elapsed = dictionary["elapsed"] as? Int;
        self.isPlaying = dictionary["isPlaying"] as? Bool;
        self.hasPrev = dictionary["hasPrev"] as? Bool;
        self.hasNext = dictionary["hasNext"] as? Bool;
        self.hasSkipForward = dictionary["hasSkipForward"] as? Bool;
        self.hasSkipBackward = dictionary["hasSkipBackward"] as? Bool;
        
        self.hasScrubbing = dictionary["hasScrubbing"] as? Bool;
        self.skipForwardInterval = dictionary["skipForwardInterval"] as? NSNumber;
        self.skipBackwardInterval = dictionary["skipBackwardInterval"] as? NSNumber;
        self.dismissable = dictionary["dismissable"] as? Bool;

    }
    
 
    
}
