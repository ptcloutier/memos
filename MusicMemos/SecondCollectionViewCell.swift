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
        
        recordBtn.addTarget(self, action: #selector(SecondCollectionViewCell.recordBtnDidPress), for: .touchUpInside)
        
        doneBtn.isUserInteractionEnabled = false
        doneBtn.titleLabel?.textColor = UIColor.gray
        doneBtn.addTarget(self, action: #selector(SecondCollectionViewCell.doneBtnDidPress), for: .touchUpInside)
        
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
        print("why god")
//        switch AudioManager.shared.isRecording {
//        case true:
//            let flag = AudioManager.shared.recordFile()
//            if flag == 0 {
//                recordBtnDelegate?.displayAlert(title:  "Oops!", message: "Recording failed")
//            }
//        case false:
//            AudioManager.shared.stopRecording()
//            NotificationCenter.default.post(name: Notification.Name.init(reloadDataNotification), object: nil)
//        }
//        
//        recordBtnDelegate?.recordButtonDidPress()
//        recordBtnAnimation()
    }
    
    
    @objc func doneBtnDidPress(){
        recordBtnDelegate?.doneButtonDidPress()
    }
}
