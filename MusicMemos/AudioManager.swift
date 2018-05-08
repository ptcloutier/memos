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
}
