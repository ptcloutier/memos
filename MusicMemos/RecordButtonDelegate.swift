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
    func recordButtonDidPress(sender: UIButton)
    
    func doneButtonDidPress(sender: UIButton)
    
    func moveTableViewUp(sender: UIButton)
    
    func moveTableViewDown(sender: UIButton)
}
