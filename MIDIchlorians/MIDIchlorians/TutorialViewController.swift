//
//  TutorialViewController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 7/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit
import SnapKit
import ImageSlideshow

// Shows the tutorial
class TutorialViewController: UIViewController {
    var closeButton = UIButton(type: .system)
    let images = Config.TutorialImages
    var currentIndex = 0
    var slideshow = ImageSlideshow()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        buildViewHierarchy()
        addTargetAction()
        buildConstraints()
    }

    func setUp() {
        slideshow.backgroundColor = UIColor.clear
        slideshow.pageControlPosition = PageControlPosition.underScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideshow.pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
        let sources = Config.TutorialImages.map { ImageSource(imageString: $0)! }
        slideshow.setImageInputs(sources)

        view.backgroundColor = UIColor.white

        closeButton.setTitle(Config.AboutCloseTitle, for: .normal)
        closeButton.setTitleColor(UIColor.black, for: .normal)
    }

    func buildViewHierarchy() {
        view.addSubview(slideshow)
        view.addSubview(closeButton)
    }

    func addTargetAction() {
        closeButton.addTarget(self, action: #selector(closeButtonDown), for: .touchDown)
    }

    func buildConstraints() {
        slideshow.snp.makeConstraints { make in
            make.edges.equalTo(view).inset(Config.AboutSlideshowInset)
        }

        closeButton.snp.makeConstraints { make in
            make.top.right.equalTo(view).inset(Config.AboutCloseInset)
            make.height.width.equalTo(Config.AboutCloseWidth)
        }
    }

    func closeButtonDown() {
        dismiss(animated: true, completion: nil)
    }
}
