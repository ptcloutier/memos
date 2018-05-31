//
//  FirstCollectionViewCell.swift
//  MusicMemos
//
//  Created by Perrin Cloutier on 5/9/18.
//  Copyright © 2018 Perrin Cloutier. All rights reserved.
//
import FDWaveformView
import UIKit

class FirstCollectionViewCell: UICollectionViewCell {
  
    var waveformView = FDWaveformView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupWaveformView(){
        
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        waveformView.frame = frame
        self.contentView.addSubview(waveformView)
    }
    
}
