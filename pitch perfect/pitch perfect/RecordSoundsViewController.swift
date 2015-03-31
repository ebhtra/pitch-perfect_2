//
//  RecordSoundsViewController.swift
//  pitch perfect
//
//  Created by Ethan Haley on 3/12/15.
//  Copyright (c) 2015 Ethan Haley. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var showRecording: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var tapMicLabel: UILabel!
    @IBOutlet weak var tapStopLabel: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func prepareRecordingUI() {
        //set UI elements ready to record
        stopButton.hidden = true
        tapStopLabel.hidden = true
        tapMicLabel.hidden = false
        recordButton.enabled = true
        showRecording.hidden = true
    }
    
    func prepareStopRecordingUI() {
        //set UI elements ready to stop recording
        stopButton.hidden = false
        tapStopLabel.hidden = false
        tapMicLabel.hidden = true
        recordButton.enabled = false
        showRecording.hidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        prepareRecordingUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        prepareStopRecordingUI()
        //find directory in device to store audio, and create unique filename for current recording
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url!, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("recording didn't finish successfully")
            prepareRecordingUI()
        }
    }

    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            //store audio in global variable of next controller
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
}

