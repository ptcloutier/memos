//
//  Recording.swift
//  MusicMemos
//
//  Created by Perrin Cloutier on 5/13/18.
//  Copyright © 2018 Perrin Cloutier. All rights reserved.
//

import Foundation

class Recording {
    
    let number: Int!
    let filepath: String!
    let dateCreated: String!
    var duration: Double!
    
    init(number: Int, filepath: String, dateCreated: String, duration: Double ){
        self.number = number
        self.filepath = filepath
        self.dateCreated = dateCreated
        self.duration = duration
    }
}
