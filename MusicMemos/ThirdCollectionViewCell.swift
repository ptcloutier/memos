//
//  ThirdCollectionViewCell.swift
//  MusicMemos
//
//  Created by Perrin Cloutier on 5/9/18.
//  Copyright © 2018 Perrin Cloutier. All rights reserved.
//

import UIKit
import AVFoundation


let recordingsTableViewCellReuseIdentifier = "recordingsTableViewCell"
let recordingsTableViewCellNibName = "RecordingsTableViewCell"
let reloadDataNotification = "ReloadDataNotification"



class ThirdCollectionViewCell: UICollectionViewCell, AVAudioRecorderDelegate {
    
    weak var recordBtnDelegate: RecordButtonDelegate?
    var recordBtn: UIButton!
    var tableView = UITableView()
    var cellID = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupTableView(){

        tableView = UITableView(frame: self.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: recordingsTableViewCellNibName, bundle: nil), forCellReuseIdentifier: recordingsTableViewCellReuseIdentifier)

        contentView.addSubview(tableView)
 
        NotificationCenter.default.addObserver(self, selector: #selector(ThirdCollectionViewCell.reload), name: Notification.Name.init(reloadDataNotification), object: nil)
     }
    
    
    @objc func reload(){ 
        self.tableView.reloadData()
    }
}



extension ThirdCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if cellID == AudioManager.shared.selectedAudiofile {
             return 150.0
        } else {
             return 75.0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(AudioManager.shared.numberOfRecords)")
        return AudioManager.shared.numberOfRecords+1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: recordingsTableViewCellReuseIdentifier) as! RecordingsTableViewCell
        
        cellID = indexPath.row
        cell.recordingNameLabel.text = "recording #\(indexPath.row+1)"

        let duration = AudioManager.shared.getAudioFileDuration(index: indexPath.row)

        if duration != "" {
            cell.durationLabel.text = duration
        } else {
            cell.durationLabel.text = ""
        }
        let recordingDate = AudioManager.shared.getDate()
        cell.dateLabel.text = recordingDate
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        AudioManager.shared.playFile(index: indexPath.row)
        AudioManager.shared.selectedAudiofile = indexPath.row
 
        NotificationCenter.default.post(name: Notification.Name.init(reloadWaveformNotification), object: nil)
        print("no. of records - \(AudioManager.shared.numberOfRecords)/n selected audio file - \(AudioManager.shared.selectedAudiofile)")
    }
}

