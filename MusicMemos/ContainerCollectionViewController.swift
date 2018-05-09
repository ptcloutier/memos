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

class ContainerCollectionViewController: UICollectionViewController {
    
    @IBOutlet var cv: UICollectionView!
    var secondCellExpanded: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        cv.register(FirstCollectionViewCell.self, forCellWithReuseIdentifier: firstCellID)
        cv.register(SecondCollectionViewCell.self, forCellWithReuseIdentifier: secondCellID)
        cv.register(ThirdCollectionViewCell.self, forCellWithReuseIdentifier: thirdCellID)
        let layout = FlowLayout.init(direction: .vertical, numberOfColumns: 1)
        cv.collectionViewLayout = layout
     }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    

    // MARK: UICollectionViewDataSource

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
            cell.backgroundColor = UIColor.orange
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: thirdCellID, for: indexPath) as! ThirdCollectionViewCell
            cell.backgroundColor = UIColor.purple
            return cell
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

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
            if secondCellExpanded == true {
                size = CGSize.init(width: w, height: h/3.0)
            } else {
                size = CGSize.init(width: w, height: (h/3.0)/2.0)
            }
        case 2:
            if secondCellExpanded == true {
                size = CGSize.init(width: w, height: h - ((h/3.0)*2.0))
            } else {
                size = CGSize.init(width: w, height: (h - (h/3.0))-(h/3.0)/2.0)
            }
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