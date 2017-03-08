//
//  ViewController.swift
//  LaunchpadPrototype
//
//  Created by Ten Zhi yang on 28/2/17.
//  Copyright © 2017 Ten Zhi yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    UIGestureRecognizerDelegate {

    @IBOutlet weak var buttonCollectionView: UICollectionViewExtension!

    var DEFAULT_BUTTON_SIZE = CGSize(width: 0, height: 0)
    let ITEMS_PER_ROW = 8
    let NUMBER_OF_SECTIONS = 8
    let SECTION_INSETS = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    let ITEM_INSETS = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    let reuseIdentifier = "cell"
    private let items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        buttonCollectionView.isUserInteractionEnabled = true
        buttonCollectionView.isMultipleTouchEnabled = true
        calculateWidthPerItem()
        buttonCollectionView.startListenAudio()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func calculateWidthPerItem() {
        let totalLength = buttonCollectionView.frame.width
        var insetLength = ITEM_INSETS.left * CGFloat(ITEMS_PER_ROW - 1)
        insetLength += SECTION_INSETS.left + SECTION_INSETS.right
        let availableLength = totalLength - insetLength
        let itemLength = availableLength / CGFloat(ITEMS_PER_ROW)
        DEFAULT_BUTTON_SIZE = CGSize(width: itemLength, height: itemLength)
    }

    //collecton view functions
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ITEMS_PER_ROW
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return NUMBER_OF_SECTIONS
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return DEFAULT_BUTTON_SIZE
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return SECTION_INSETS
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return ITEM_INSETS.left
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ITEM_INSETS.top
    }

    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath as IndexPath)
        cell.backgroundColor = UIColor.gray
        return cell
    }

}

