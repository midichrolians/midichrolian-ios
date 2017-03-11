//
//  ViewController.swift
//  LaunchpadPrototype
//
//  Created by Ten Zhi yang on 28/2/17.
//  Copyright © 2017 Ten Zhi yang. All rights reserved.
//

import UIKit

class EditPane: NSObject {
    weak var superview: UIView?
    var view: UIView

    init(superview: UIView) {
        self.superview = superview
        // TODO remove constant
        let baseWidth = (self.superview?.frame.width ?? 100) * 0.25
        let x = (self.superview?.frame.width ?? 100) - 20 - baseWidth
        self.view = UIView(frame: CGRect(
            origin: CGPoint(x: x, y: 90),
            size: CGSize(width: baseWidth, height: 500)))
        let tabBar = UITabBar(frame: CGRect(x: 0, y: 0, width: baseWidth, height: 50))
        tabBar.items = [
            UITabBarItem(title: "Sessions", image: nil, selectedImage: nil),
            UITabBarItem(title: "Samples", image: nil, selectedImage: nil)
        ]
        self.view.isHidden = true
        self.view.addSubview(tabBar)
        superview.addSubview(self.view)
        super.init()
    }
    
}

extension ViewController: EditButtonDelegate {
    func editStart() {
        print("edit start")
        resizePads(by: Constants.PadAreaResizeFactorWhenEditStart)
        self.editPaneController?.view.isHidden = false
    }
    
    func editEnd() {
        print("edit eend")
        self.editPaneController?.view.isHidden = true
        resizePads(by: Constants.PadAreaResizeFactorWhenEditEnd)
    }

    private func resizePads(by factor: CGFloat) {
        print("resizing")
        // TODO extend UIView to add methods for updating size?
        // and to animate the changes refer to
        // http://stackoverflow.com/questions/13780153/uicollectionview-animate-cell-size-change-on-selection
        self.buttonCollectionView.frame = CGRect(
            origin: self.buttonCollectionView.frame.origin,
            size: self.buttonCollectionView.frame.size.scale(by: factor))
        self.buttonCollectionView.collectionViewLayout.invalidateLayout()
    }
}

class ViewController: UIViewController,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    UIGestureRecognizerDelegate {

    @IBOutlet weak var buttonCollectionView: UICollectionViewExtension!
    var editButtonController: EditButton!
    var editPaneController: EditPane?
    var padWidth: CGFloat?

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
        self.padWidth = padWidth
        let padHeight = padWidth / 8 * 6
        buttonCollectionView.frame = CGRect(
            origin: buttonCollectionView.frame.origin,
            size: CGSize(width: padWidth, height: padHeight))

        editButtonController = EditButton(superview: self.view, delegate: self)

        self.view.backgroundColor = Constants.BackgroundColor
        // set the collection view background to transparent
        buttonCollectionView.backgroundColor = nil
        buttonCollectionView.isUserInteractionEnabled = true
        buttonCollectionView.isMultipleTouchEnabled = true
        buttonCollectionView.startListenAudio()

        self.editPaneController = EditPane(superview: self.view)
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

