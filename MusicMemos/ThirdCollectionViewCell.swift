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
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupTableView(){
        

        tableView = UITableView(frame: self.contentView.bounds, style: UITableViewStyle.plain)
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
            return 75.0
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(AudioManager.shared.numberOfRecords)")
        return AudioManager.shared.numberOfRecords+1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: recordingsTableViewCellReuseIdentifier) as! RecordingsTableViewCell
        
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
        // TODO: - Expand cells upon selection
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        print("selected audio file - \(AudioManager.shared.selectedAudiofile)")
    }
}

