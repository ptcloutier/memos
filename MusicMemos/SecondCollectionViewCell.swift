//
//  SecondCollectionViewCell.swift
//  MusicMemos
//
//  Created by Perrin Cloutier on 5/9/18.
//  Copyright © 2018 Perrin Cloutier. All rights reserved.
//

import UIKit



class SecondCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recordingTitleLabel: UILabel!
    @IBOutlet weak var blackCircle: UIView!
    @IBOutlet weak var whiteCircle: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    weak var recordBtnDelegate: RecordButtonDelegate?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func setupRecordBtnDelegate(delegate: RecordButtonDelegate){
        recordBtnDelegate = delegate
    }
    
    
    func setupRecordBtn(){
        recordBtn.layer.borderColor = UIColor.black.cgColor
        recordBtn.layer.borderWidth = 2.0
        blackCircle.layer.cornerRadius = blackCircle.frame.width/2.0
        whiteCircle.layer.cornerRadius = whiteCircle.frame.width/2.0
        recordBtn.layer.cornerRadius = recordBtn.frame.width/2.0
        
        doneBtn.isUserInteractionEnabled = false
        doneBtn.titleLabel?.textColor = UIColor.gray
        
        playBtn.isHidden = true
        doneBtn.isHidden = true
        recordingTitleLabel.isHidden = true
        dateLabel.isHidden = true
        timeLabel.isHidden = true
        
    }
    
    
    
    
    

    
    
    @IBAction func recordBtnDidPress(_ sender: Any) {
        
        switch AudioManager.shared.isRecording {
        
        case true:
            
            playBtn.isHidden = true
            doneBtn.isHidden = true
            recordingTitleLabel.isHidden = true
            dateLabel.isHidden = true
            timeLabel.isHidden = true
            
            
            AudioManager.shared.isRecording = false
            AudioManager.shared.stopRecording()
           
            UIView.animate(withDuration: 0.5, animations: {
                self.recordBtn.transform = CGAffineTransform.identity
                self.recordBtn.layer.cornerRadius = self.recordBtn.frame.width*0.5
            })
            
            doneBtn.titleLabel?.textColor = UIColor.white
            doneBtn.isUserInteractionEnabled = true
            
            self.playBtn.alpha = 1.0
            self.playBtn.isUserInteractionEnabled = true
            
            NotificationCenter.default.post(name: Notification.Name.init(reloadDataNotification), object: nil)
            recordBtnDelegate?.recordButtonDidPress()
       
        case false:
            
            playBtn.isHidden = false
            doneBtn.isHidden = false
            recordingTitleLabel.isHidden = false
            dateLabel.isHidden = false
            timeLabel.isHidden = false 
            
            
            AudioManager.shared.isRecording = true

            let flag = AudioManager.shared.recordFile()
            if flag == 0 {
                recordBtnDelegate?.displayAlert(title:  "Oops!", message: "Recording failed")
            }
            UIView.animate(withDuration: 0.3, animations: {
                self.recordBtn.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.recordBtn.layer.cornerRadius = self.recordBtn.frame.width*0.25
            })
            
            doneBtn.isHidden = false
            doneBtn.titleLabel?.textColor = UIColor.gray
            doneBtn.isUserInteractionEnabled = false
            
            self.playBtn.isHidden = false
            self.playBtn.alpha = 0.5
            self.playBtn.isUserInteractionEnabled = false
            
            recordBtnDelegate?.recordButtonDidPress()
        }
    }
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var view = self.recordBtn.hitTest(self.recordBtn.convert(point, from: self), with: event)
        if view == nil {
            view = super.hitTest(point, with: event)
        }
        return view
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if super.point(inside: point, with: event) {
            return true
        }
        return !self.recordBtn.isHidden && self.recordBtn.point(inside: self.recordBtn.convert(point, from: self), with: event)
    }
    
        
        
        
        
        @objc func doneBtnDidPress(){
            recordBtnDelegate?.doneButtonDidPress()
        }
}
