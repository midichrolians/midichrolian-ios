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
    var auxButtonCollectionView: UICollectionView!

    var DEFAULT_BUTTON_SIZE = CGSize(width: 0, height: 0)
    let ITEMS_PER_ROW = 8
    let NUMBER_OF_SECTIONS = 6
    let SECTION_INSETS = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    let ITEM_INSETS = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    let reuseIdentifier = "cell"
    private let items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // fix the width of the button collection view
        let totalWidth = self.view.frame.width - 20 - 20 // padding left and right
        // left with 9 columns of buttons with 8 insets in between
        // so to get width for the pads we add 1 inset and times 8/9
        let padWidth = (totalWidth + ITEM_INSETS.right) * 8 / 9
        let padHeight = padWidth / 8 * 6
        let auxWidth = (totalWidth + ITEM_INSETS.right) / 9
        buttonCollectionView.frame = CGRect(
            origin: buttonCollectionView.frame.origin,
            size: CGSize(width: padWidth, height: padHeight))

        auxButtonCollectionView = UICollectionView(
            frame: CGRect(
                origin: CGPoint(x: padWidth + ITEM_INSETS.right, y: buttonCollectionView.frame.minY),
                size: CGSize(width: auxWidth, height: padHeight)),
            collectionViewLayout: UICollectionViewLayout()
        )
        auxButtonCollectionView.backgroundColor = UIColor.blue;

        self.view.backgroundColor = Constants.BackgroundColor
        // set the collection view background to transparent
        buttonCollectionView.backgroundColor = nil
        buttonCollectionView.isUserInteractionEnabled = true
        buttonCollectionView.isMultipleTouchEnabled = true
        buttonCollectionView.startListenAudio()

        self.view.addSubview(auxButtonCollectionView)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ITEMS_PER_ROW
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return NUMBER_OF_SECTIONS
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalLength = buttonCollectionView.frame.width
        let insetLength = ITEM_INSETS.left * (CGFloat(ITEMS_PER_ROW + 1))
        let availableLength = totalLength - insetLength
        let itemLength = availableLength / CGFloat(ITEMS_PER_ROW)

        DEFAULT_BUTTON_SIZE = CGSize(width: itemLength, height: itemLength)
        print(DEFAULT_BUTTON_SIZE)
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

