//
//  DataManager.swift
//  MusicMemos
//
//  Created by Perrin Cloutier on 5/13/18.
//  Copyright © 2018 Perrin Cloutier. All rights reserved.
//

import Foundation

class DataManager: NSObject {
    
    override private init() {}
    
    private let shared = DataManager()
    
    var recordings = [String]()
    
}
