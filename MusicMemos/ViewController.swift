//
//  ViewController.swift
//  MusicMemos
//
//  Created by Perrin Cloutier on 5/8/18.
//  Copyright © 2018 Perrin Cloutier. All rights reserved.
//

import UIKit
import AVFoundation



class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    
    @IBOutlet weak var waveformView: UIView!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var numberOfRecords: Int = 0
    var audioPlayer: AVAudioPlayer!
    let recordingsTableViewCellReuseIdentifier = "recordingsTableViewCell"
    let recordingsTableViewCellNibName = "RecordingsTableViewCell"
    let recordingControlsViewNibName = "RecordingControlsView"
    var numberKey = "myNumber"
    let sampleRate = 12000
    var isRecording = false
    var showWaveform = false
    @IBOutlet weak var recordingsTableView: UITableView!
    
    var recordBtn: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set up header view
        
        
        guard let header = Bundle.main.loadNibNamed(recordingControlsViewNibName, owner: self, options: nil)![0] as? RecordingControlsView else {
            print("error loading nib")
            return
        }
        
        header.setupRecordBtn()
        header.setupRecordBtnDelegate(delegate: self)
        recordingsTableView.tableHeaderView = header
        
        // Register cell
        recordingsTableView.register(UINib.init(nibName: recordingsTableViewCellNibName, bundle: nil), forCellReuseIdentifier: recordingsTableViewCellReuseIdentifier)
        
        recordingsTableView.backgroundColor = UIColor.white
        
        
        // Setting up the audio session
        recordingSession = AVAudioSession.sharedInstance()
        
        if let number: Int = UserDefaults.standard.object(forKey: numberKey) as? Int {
            numberOfRecords = number
        }
        
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            
            if hasPermission {
                print("ACCEPTED")
            }
        }
    }
    
    
    
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    
    func displayAlert(title: String, message: String){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "done", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    func getDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        return dateFormatter.string(from: date)
    }
    
    func getAudioFileDuration(index: Int) -> String? {
        let path = getDirectory().appendingPathComponent("\(index+1).m4a")
        do {
            let audioFile = try AVAudioFile(forReading: path)
            let duration = Float(audioFile.length/12000)
            
            let hours = Int(duration / 3600)
            let minutes = Int((duration.truncatingRemainder(dividingBy: 3600)) / 60)
            let seconds = Int(duration.truncatingRemainder(dividingBy: 60))
            let durationString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            return durationString
        } catch {
            print("error getting duration - getAudioFileDuration")
            return ""
        }
    }
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRecords
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: recordingsTableViewCellReuseIdentifier) as! RecordingsTableViewCell
        cell.recordingNameLabel.text = "recording #\(indexPath.row+1)"
        
        let duration = getAudioFileDuration(index: indexPath.row)
        
        if duration != "" {
            cell.durationLabel.text = duration
        } else {
            cell.durationLabel.text = ""
        }
        
        let recordingDate = getDate()
        cell.dateLabel.text = recordingDate
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let path = getDirectory().appendingPathComponent("\(indexPath.row+1).m4a")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer.play()
        }
        catch {
            print("error playing file in didSelectRowAt")
        }
    }
    
    
}



extension ViewController: RecordButtonDelegate {
    
    func recordButtonDidPress(sender: UIButton){
        
        if audioRecorder == nil {
            numberOfRecords += 1
            let filename = getDirectory().appendingPathComponent("\(numberOfRecords).m4a")
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: sampleRate, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            // Start audio recording
            do {
                audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                isRecording = true
                AudioManager.shared.isRecording = true
            } catch {
                displayAlert(title: "Oops!", message: "Recording failed")
            }
        } else {
            audioRecorder.stop()
            audioRecorder = nil
            isRecording = false
            AudioManager.shared.isRecording = false
            
            UserDefaults.standard.set(numberOfRecords, forKey: numberKey)
            recordingsTableView.reloadData()
        }
    }
    
    func doneButtonDidPress(sender: UIButton) {
        let alertView = UIAlertController.init(title: "Save Voice Memo", message: "", preferredStyle: .actionSheet)
        alertView.addAction(UIAlertAction.init(title: "Delete", style: .destructive, handler: nil))
        alertView.addAction(UIAlertAction.init(title: "Save", style: .default, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
    
    
    func moveTableViewUp(sender: UIButton) {
        UIView.animate(withDuration: 1.0, animations: {
            self.recordingsTableView.frame.origin.y = self.recordingsTableView.frame.origin.y-300.0
        })
    }
    
    
    func moveTableViewDown(sender: UIButton) {
        UIView.animate(withDuration: 1.0, animations: {
            self.recordingsTableView.frame.origin.y = self.recordingsTableView.frame.origin.y+300.0
        })
    }
}
