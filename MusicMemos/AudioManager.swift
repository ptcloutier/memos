//
//  AudioManager.swift
//  VoiceMemos
//
//  Created by Perrin Cloutier on 5/7/18.
//  Copyright © 2018 Perrin Cloutier. All rights reserved.
//

import Foundation
import AVFoundation

class AudioManager: NSObject, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    /* TODO: several states will need to be accounted for:
    // recoding, recording paused, audiofile selected, playing, playing paused, editing
    
    Recording states
    
    Ready
    
    Play
    —— pause
    —— finish/save
    —— edit
    
    Edit
    - Shows whole waveform
    - Can drag edit bar to edit and trim (Zoom in on edit bar drag )
    - Can drag play bar (Does not zoom)
    - cancel (go back to play view)
    - delete
    - play
    - trim - trims audiofile and goes back to play view
    
    My shit ->
    - Add sampling power by stretching color coded sections in this view
    - Standard naming conventions (audiofile name - sample 1 ... 99)
    - Samples will populate in tableview also (or maybe their own section or their own tableview)
    - mixer controls
    - Eq, pan, volume, lp filter, hp, reverb, delay, distortion, pitch, time, tremolo, repeater, audiobus apps,
    
    Record
    —— pause
    ———— playback
    ———— finish/save */
    
    
    enum RecorderState {
        
        case Ready
        case ReadyAudiofileSelected
        case Recording
        case RecordingPaused
        case Playing
        case PlayingPaused
        case Editing
    }
    override private init() {}
    
    static let shared = AudioManager()
    
    var currentStateStatus: RecorderState = .Ready
    var isRecording = false
    var isPaused = false
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var numberOfRecords: Int = 0
    var audioPlayer: AVAudioPlayer!
    var numberKey = "myNumber"
    let sampleRate = 12000
    var selectedAudiofile: Int = 0 
    
    
    func setupAudioSession(){
        // Setting up the audio session
        recordingSession = AVAudioSession.sharedInstance()
        
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            
            if hasPermission {
                print("ACCEPTED")
            }
        }
    }
    
    
    
    func getNumberOfRecords(){
        if let number: Int = UserDefaults.standard.object(forKey: numberKey) as? Int {
            numberOfRecords = number
        }
    }
    
    
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
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
    
    
    func getAudiofilePath(index: Int) -> URL {
        let path = getDirectory().appendingPathComponent("\(index+1).m4a")
        return path
    }
    
    
    func playFile(index: Int){
        let path = getDirectory().appendingPathComponent("\(index+1).m4a")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer.play()
        }
        catch {
            print("error playing file in didSelectRowAt")
        }
    }
    
    
    func recordFile() -> Bool {
        
            numberOfRecords += 1
            let filename = getDirectory().appendingPathComponent("\(numberOfRecords).m4a")
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: sampleRate, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            // Start audio recording
            do {
                audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                print("Recording started")
                return true // success
            } catch {
                print("Recording failed")
                return false // display alert
            }
    }
    
    
    func stopRecording(){
        audioRecorder.stop()
        audioRecorder = nil
        print("Recording stopped")
        UserDefaults.standard.set(numberOfRecords, forKey: numberKey)
    }
}
