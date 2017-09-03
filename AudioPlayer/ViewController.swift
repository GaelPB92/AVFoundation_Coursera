//
//  ViewController.swift
//  AudioPlayer
//
//  Created by Gael Perez on 8/28/17.
//  Copyright © 2017 Coursera. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate, AVAudioPlayerDelegate{

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var songTittle: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var songSelector: UIPickerView!
    
    var songs = [Song]()
    var currentPlayer:AVAudioPlayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        songs.append(Song(withSongName: "Time is running out",
                          coverURL: "http://www.humanconnectomeproject.org/wp-content/uploads/2012/10/Muse_album-cover.jpeg",
                          fileName: "baby"))
        
        songs.append(Song(withSongName: "Survival",
                          coverURL: "http://diffuser.fm/files/2015/11/Muse-Absolution.jpg",
                          fileName: "flock"))
        
        songs.append(Song(withSongName: "New Born",
                          coverURL: "https://i.pinimg.com/originals/6d/2c/59/6d2c593ce51c524929062511511e73b3.jpg",
                          fileName: "hyena"))
        
        songs.append(Song(withSongName: "Knights of Cydonia",
                          coverURL: "https://cbsradionews.files.wordpress.com/2015/03/1796961_10152887723498725_8861966302134959842_o.jpg",
                          fileName: "meadowlark"))
    
        changeSongInfo(0)
        
    }


    // MARK: IBActions
    @IBAction func playAction(_ sender: Any) {
        
        let index = songSelector.selectedRow(inComponent: 0)
        currentPlayer = songs[index].getPlayerItem()
        currentPlayer?.delegate = self
        changeVolume(sender)
        
        if !playButton.isSelected {
            currentPlayer?.play()
            stopButton.isEnabled = true
        } else{
            currentPlayer?.pause()
        }
        
        playButton.isSelected = playButton.isSelected ? false : true
    }
    
    @IBAction func stopAction(_ sender: Any) {
        currentPlayer?.stop()
        currentPlayer?.currentTime = 0
        playButton.isSelected = false
    }
    
    @IBAction func shuffleAction(_ sender: Any) {
        stopAction(sender)
        let random = Int(arc4random() % 4)
        changeSongInfo(random)
        songSelector.selectRow(random, inComponent: 0, animated: true)
        playAction(sender)
    }
    
    @IBAction func changeVolume(_ sender: Any) {
        currentPlayer?.volume = volumeSlider.value
    }
    
    // MARK: Picker View
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return songs.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return songs[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stopAction(pickerView)
        changeSongInfo(row)
        playAction(pickerView)
    }
    
    // MARK: Aditional Functions
    func changeSongInfo(_ index:Int) {
        coverImage.image = nil
        indicatorView.startAnimating()
        songs[index].getCoverImage(completion: { image in
            DispatchQueue.main.async {
                self.indicatorView.stopAnimating()
                self.coverImage.image = image
            }
        })
        
        songTittle.text =  songs[index].name
        currentPlayer?.stop()
        playButton.isSelected = false
        stopButton.isEnabled = false
    }
    
    // MARK: Audio Player Delegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playButton.isSelected = false
        stopButton.isEnabled = false
    }
    

}

