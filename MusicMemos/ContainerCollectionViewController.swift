//
//  ContainerCollectionViewController.swift
//  MusicMemos
//
//  Created by Perrin Cloutier on 5/9/18.
//  Copyright © 2018 Perrin Cloutier. All rights reserved.
//

import UIKit

private let firstCellID = "FirstCell"
private let secondCellID = "SecondCell"
private let thirdCellID = "ThirdCell"

private let secondNib = "SecondCollectionViewCell"


class ContainerCollectionViewController: UICollectionViewController {
    
    @IBOutlet var cv: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        cv.register(FirstCollectionViewCell.self, forCellWithReuseIdentifier: firstCellID)
        cv.register(UINib(nibName: secondNib, bundle: nil), forCellWithReuseIdentifier: secondCellID)
        cv.register(ThirdCollectionViewCell.self, forCellWithReuseIdentifier: thirdCellID)
        let layout = FlowLayout.init(direction: .vertical, numberOfColumns: 1)
        cv.collectionViewLayout = layout
        cv.isScrollEnabled = false 
     }



    // MARK: Collectionview data source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: firstCellID, for: indexPath) as! FirstCollectionViewCell
            cell.backgroundColor = UIColor.red
            return cell
        }
        if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: secondCellID, for: indexPath) as! SecondCollectionViewCell
            cell.setupRecordBtn()
            cell.setupRecordBtnDelegate(delegate: self)
            cell.dateLabel.text = AudioManager.shared.getDate()
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: thirdCellID, for: indexPath) as! ThirdCollectionViewCell
            cell.setupTableView()
            return cell
        }
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}


// MARK: UICollectionViewDelegateFlowLayout
extension ContainerCollectionViewController:  UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size: CGSize
        let w = collectionView.frame.size.width
        let h = collectionView.frame.size.height
        
        switch indexPath.row  {
        case 0:
            size = CGSize.init(width: w, height: h/3.0)

        case 1:
            size = CGSize.init(width: w, height: 150.0)
        case 2:
            size = CGSize.init(width: w, height: h )

        default:
            size = CGSize.init(width: w, height: h/3.0)
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
}



extension ContainerCollectionViewController: RecordButtonDelegate {
  
    func recordButtonDidPress(){
        switch AudioManager.shared.isRecording {
        case true:
            print("cv up")
            UIView.animate(withDuration: 1.0, animations: {
                self.cv.frame.origin.y = self.cv.frame.origin.y + 290.0
            })
        case false:
            UIView.animate(withDuration: 1.0, animations: {
                self.cv.frame.origin.y = self.cv.frame.origin.y  - 290.0
            })
        }
    }

    
    func doneButtonDidPress() {
        let alertView = UIAlertController.init(title: "Save Voice Memo", message: "", preferredStyle: .actionSheet)
        alertView.addAction(UIAlertAction.init(title: "Delete", style: .destructive, handler: nil))
        alertView.addAction(UIAlertAction.init(title: "Save", style: .default, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
    
    
    
    func displayAlert(title: String, message: String){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "done", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


