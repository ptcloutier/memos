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

    var expandCell: Bool = false
    
    var recordBtn: UIButton!
    
    var recordingsTableView = UITableView()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupTableView(){
        let size = CGSize(width: self.frame.width, height: self.frame.height)
        let point = CGPoint(x: self.frame.origin.x, y: self.frame.origin.y)
        recordingsTableView = UITableView.init(frame: CGRect(origin: point, size: size))
        recordingsTableView.delegate = self
        recordingsTableView.dataSource = self
        self.addSubview(recordingsTableView)
        self.bringSubview(toFront: recordingsTableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ThirdCollectionViewCell.reload), name: Notification.Name.init(reloadDataNotification), object: nil)
        
        recordingsTableView.register(UINib.init(nibName: recordingsTableViewCellNibName, bundle: nil), forCellReuseIdentifier: recordingsTableViewCellReuseIdentifier)
     }
    
    
    @objc func reload(){
        recordingsTableView.reloadData()
    }
}



extension ThirdCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if expandCell == true{
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
        cell.recordingNameLabel.text = "recording #\(indexPath.row-1)"
        
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
        tableView.beginUpdates()
        tableView.endUpdates()
    }

}

