//
//  RecordControlsTableViewCell.swift
//  VoiceMemos
//
//  Created by Perrin Cloutier on 5/7/18.
//  Copyright © 2018 Perrin Cloutier. All rights reserved.
//

import UIKit

class RecordingControlsCell: UITableViewCell {
    
    var view: UIView!

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recordingTitleLabel: UILabel!
    @IBOutlet weak var blackCircle: UIView!
    @IBOutlet weak var whiteCircle: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    weak var recordBtnDelegate: RecordButtonDelegate?
    var tableViewPosition: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func setupRecordBtnDelegate(delegate: RecordButtonDelegate){
        recordBtnDelegate = delegate
    }
    
    
    func setupRecordBtn(){
        recordBtn.layer.borderColor = UIColor.black.cgColor
        recordBtn.layer.borderWidth = 1.0
        blackCircle.layer.cornerRadius = blackCircle.frame.width/2.0
        whiteCircle.layer.cornerRadius = whiteCircle.frame.width/2.0
        recordBtn.layer.cornerRadius = recordBtn.frame.width/2.0
        
        recordBtn.addTarget(self, action: #selector(RecordingControlsCell.recordBtnDidPress), for: .touchUpInside)
        
        doneBtn.isUserInteractionEnabled = false
        doneBtn.titleLabel?.textColor = UIColor.gray
        doneBtn.addTarget(self, action: #selector(RecordingControlsCell.doneBtnDidPress), for: .touchUpInside)
        
        self.playBtn.isHidden = true
        self.doneBtn.isHidden = true
        
    }
    
    
    func recordBtnAnimation(){
        switch AudioManager.shared.isRecording {
        case true:
            UIView.animate(withDuration: 0.3, animations: {
                self.recordBtn.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.recordBtn.layer.cornerRadius = self.recordBtn.frame.width*0.25
            })
            disablePlayDoneBtn()
        case false:
            UIView.animate(withDuration: 0.5, animations: {
                self.recordBtn.transform = CGAffineTransform.identity
                self.recordBtn.layer.cornerRadius = self.recordBtn.frame.width*0.5
            })
            enablePlayDoneBtn()
        }
    }
    
    
    
    
    func disablePlayDoneBtn() {
        doneBtn.isHidden = false
        doneBtn.titleLabel?.textColor = UIColor.gray
        doneBtn.isUserInteractionEnabled = false
        
        self.playBtn.isHidden = false
        self.playBtn.alpha = 0.5
        self.playBtn.isUserInteractionEnabled = false
    }
    
    
    func enablePlayDoneBtn() {
        doneBtn.titleLabel?.textColor = UIColor.white
        doneBtn.isUserInteractionEnabled = true
        self.playBtn.alpha = 1.0
        self.playBtn.isUserInteractionEnabled = true
    }
    
    
    
    @objc func recordBtnDidPress() {
        
        toggleTableViewPosition()
        recordBtnDelegate?.recordButtonDidPress(sender: self.recordBtn)
        recordBtnAnimation()
    }
    
    
    func toggleTableViewPosition(){

        switch tableViewPosition {
        case 0:
            recordBtnDelegate?.moveTableViewDown(sender: self.recordBtn)
            tableViewPosition = 1
        default:
            recordBtnDelegate?.moveTableViewUp(sender: self.recordBtn)
            tableViewPosition = 0
        }
    }
    
    
    @objc func doneBtnDidPress(){
        recordBtnDelegate?.doneButtonDidPress(sender: self.doneBtn)
    }
}

