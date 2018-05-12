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
    
    override private init() {}
    
    static let shared = AudioManager()

    var isRecording = false
    var isRecordingPaused = false
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var numberOfRecords: Int = 0
    var audioPlayer: AVAudioPlayer!
    var numberKey = "myNumber"
    let sampleRate = 12000
    
    
    
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
    
    
    func playFile(index: Int){
        let path = AudioManager.shared.getDirectory().appendingPathComponent("\(index+1).m4a")
        do {
            AudioManager.shared.audioPlayer = try AVAudioPlayer(contentsOf: path)
            AudioManager.shared.audioPlayer.play()
        }
        catch {
            print("error playing file in didSelectRowAt")
        }
    }
    
    
    func recordFile() -> Int{
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
                print("Recording started")
                return 1 // success
            } catch {
                return 0 // display alert
            }
        }
          return 1  // good enough 
    }
    
    
    func stopRecording(){
        audioRecorder.stop()
        audioRecorder = nil
        isRecording = false
        AudioManager.shared.isRecording = false
        print("Recording stopped")
        UserDefaults.standard.set(numberOfRecords, forKey: numberKey)
    }
}
