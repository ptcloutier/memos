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
    var doneBtn = UIButton()
    weak var recordBtnDelegate: RecordButtonDelegate?
    var showWaveform: Bool = true
  
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func setupRecordBtnDelegate(delegate: RecordButtonDelegate){
        recordBtnDelegate = delegate
    }
    
    
    func setupButtons(){
        recordBtn.layer.borderColor = UIColor.black.cgColor
        recordBtn.layer.borderWidth = 2.0
        blackCircle.layer.cornerRadius = blackCircle.frame.width/2.0
        whiteCircle.layer.cornerRadius = whiteCircle.frame.width/2.0
        recordBtn.layer.cornerRadius = recordBtn.frame.width/2.0
        doneBtn = UIButton.init(frame: CGRect(x: self.contentView.frame.maxX - 150.0, y: self.contentView.frame.maxY - 75.0, width: 75.0, height: 50.0))
        doneBtn.addTarget(self, action: #selector(SecondCollectionViewCell.doneBtnDidPress), for: .touchUpInside)
        doneBtn.setTitle("Done", for: .normal)
        doneBtn.titleLabel?.textColor = UIColor.white
        doneBtn.titleLabel?.font = UIFont(name: "Inter UI Bold", size: 30.0)
        self.addSubview(doneBtn)
    }
    
    
    func setButtonsState(){
       
        switch AudioManager.shared.currentStateStatus {
            
        case .Ready:
            print("State - Ready")
            self.playBtn.isHidden = false
            self.doneBtn.isHidden = false
            self.recordingTitleLabel.isHidden = false
            self.dateLabel.isHidden = false
            self.timeLabel.isHidden = false
            self.doneBtn.isUserInteractionEnabled = true
            self.playBtn.alpha = 0.5
            

        case .ReadyAudiofileSelected:
            print("State - audiofile selected")
            
        case .Recording:
            print(" State - Recording ")
          
        case .RecordingPaused:
            print("State - Recording paused")
        case .Playing:
            print("State - Playing")
        case .PlayingPaused:
            print("State - Playing paused")
        case .Editing:
            print("State - editing")
        }
    }

    
    @IBAction func recordBtnDidPress(_ sender: Any) {
        
        // TODO: recordingbuttondelegate method showwaveform works!!! use it later
                
        
        if AudioManager.shared.currentStateStatus == .Recording {
            
                UIView.animate(withDuration: 0.5, animations: {
  
                    self.recordBtn.transform = CGAffineTransform.identity
                    self.recordBtn.layer.cornerRadius = self.recordBtn.frame.width*0.5
                })
                // messages
                NotificationCenter.default.post(name: Notification.Name.init(reloadDataNotification), object: nil)
         
                // stop recording
                AudioManager.shared.stopRecording()
            
                // set state
                AudioManager.shared.currentStateStatus = .RecordingPaused
                setButtonsState()
                
        }
        else if AudioManager.shared.currentStateStatus == .Ready || AudioManager.shared.currentStateStatus == .RecordingPaused || AudioManager.shared.currentStateStatus == .PlayingPaused {
            
                // messages
                let success = AudioManager.shared.recordFile()
                if success == false {
                    recordBtnDelegate?.displayAlert(title:  "Oops!", message: "Recording failed")
                } else {
                    // TODO: send scroll message
                }
            
                // animation
                UIView.animate(withDuration: 0.5, animations: {
                    self.recordBtn.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    self.recordBtn.layer.cornerRadius = self.recordBtn.frame.width*0.25
                })
                
                // toggle bool state
                AudioManager.shared.currentStateStatus = .Recording
                setButtonsState()
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
        // option to save or delete
        recordBtnDelegate?.doneButtonDidPress()
        // after action self.currentStateStatus = .Ready
    }
}
