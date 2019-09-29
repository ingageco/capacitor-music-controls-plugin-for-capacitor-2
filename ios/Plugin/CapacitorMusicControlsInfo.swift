
import Foundation


 
@objc(CapacitorMusicControlsInfo)
public class CapacitorMusicControlsInfo: NSObject {
    

    var artist: String?;
    var track: String?;
    var album: String?;
    var ticker: String?;
    var cover: String?;
    var duration: Int?;
    var elapsed: Int?;
    var isPlaying: Bool?;
    var hasPrev: Bool?;
    var hasNext: Bool?;
    var hasSkipForward: Bool?;
    var hasSkipBackward: Bool?;
    var hasScrubbing: Bool?;
    var skipForwardInterval: NSNumber?;
    var skipBackwardInterval: NSNumber?;
    var dismissable: Bool?;
    
    
    
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
