//
//  RecordButtonDelegate.swift
//  VoiceMemos
//
//  Created by Perrin Cloutier on 5/7/18.
//  Copyright © 2018 Perrin Cloutier. All rights reserved.
//

import Foundation
import UIKit

protocol RecordButtonDelegate: class {
    
    func displayAlert(title: String, message: String)
    
    func recordButtonDidPress()
    
    func doneButtonDidPress()
    
    func showWaveformView(state: Bool)
}
