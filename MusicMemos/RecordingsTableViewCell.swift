//
//  RecordingsTableViewCell.swift
//  VoiceMemos
//
//  Created by Perrin Cloutier on 5/6/18.
//  Copyright © 2018 Perrin Cloutier. All rights reserved.
//

import UIKit

class RecordingsTableViewCell: UITableViewCell {

    @IBOutlet weak var recordingNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
}
