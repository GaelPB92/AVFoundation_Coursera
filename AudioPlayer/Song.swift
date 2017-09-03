//
//  Song.swift
//  AudioPlayer
//
//  Created by Gael Perez on 8/28/17.
//  Copyright © 2017 Coursera. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class Song {
    
    var name:String
    var coverURL:URL
    var fileURL:URL
    lazy var coverImg:UIImage? = nil
    lazy var player:AVAudioPlayer? = nil
    
    init(withSongName name:String, coverURL url:String, fileName fileN:String){
        
        self.name = name
        self.coverURL = URL(string: url)!
        self.fileURL = Bundle.main.url(forResource: fileN, withExtension: "mp3")!
        
    }
    
    func getCoverImage(completion:@escaping(UIImage?)->Void) {
        
        if self.coverImg != nil {
            completion(coverImg)
        }
        
        let task = URLSession.shared.dataTask(with: coverURL, completionHandler: { data, url, error in
            
            if let imageData = data {
                DispatchQueue.main.async {
                    self.coverImg = UIImage(data: imageData)
                    completion(self.coverImg)
                }
            } else {
                completion(nil)
            }
            
        })
        
        task.resume()
    }
    
    func getPlayerItem() -> AVAudioPlayer? {
        
        if player != nil {
            return player
        }
        
        do{
            try player = AVAudioPlayer(contentsOf: fileURL)
            return player
        }catch{
            return nil
        }
    }
    
}
