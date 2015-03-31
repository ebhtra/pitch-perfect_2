//
//  PlaySoundsViewController.swift
//  pitch perfect
//
//  Created by Ethan Haley on 3/12/15.
//  Copyright (c) 2015 Ethan Haley. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var boombox: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // I have no audio playback, so @Chrisna's workaround explicitly starts AVAudioSession:
        //(Also, I have to have something, anything, plugged into mic on mac-mini)
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        // use AVAudioPlayer to play audio fast or slowly:
        boombox = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        boombox.enableRate = true
        
        // use AVAudioEngine to alter pitch of audio:
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func startPlay(player: AVAudioPlayer!) {
        player.stop()
        audioEngine.stop()
        player.currentTime = 0.0
        player.play()
    }
    //could also add rate in next two funcs as extra argument to startPlay()
    @IBAction func playSlowaudio(sender: UIButton) {
        boombox.rate = 0.5
        startPlay(boombox)
    }
    
    @IBAction func PlayFastAudio(sender: UIButton) {
        boombox.rate = 2.0
        startPlay(boombox)
    }

    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-800)
    }
    
    func playAudioWithVariablePitch(pitchChange: Float) {
        
        boombox.stop()
        audioEngine.stop()
        //not sure why the following line of code is needed:
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitchChange
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        //start the engine by scheduling first node to play now (atTime: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()

    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        boombox.stop()
        audioEngine.stop()
    }
    
    
}
