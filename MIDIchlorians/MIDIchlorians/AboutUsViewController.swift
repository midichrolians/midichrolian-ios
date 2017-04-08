//
//  AboutUsViewController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 7/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit
import SnapKit

class AboutUsViewController: UIViewController {
    var closeButton = UIButton(type: .system)
    // Use to present the tutorial images
    var pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                  navigationOrientation: .horizontal,
                                                  options: [:])
    let images = Config.TutorialImages
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        pageViewController.dataSource = self

        self.addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParentViewController: self)

        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeButtonDown), for: .touchDown)
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(UIColor.black, for: .normal)

        setConstraints()
        // Need to set vc after constraints because vc dimensions depend on pageVIewController
        let vcs = [imageViewController(index: 0)]
        pageViewController.setViewControllers(vcs, direction: .forward, animated: false, completion: nil)
    }

    func setConstraints() {
        let inset = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        pageViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(view).inset(inset)
        }

        closeButton.snp.makeConstraints { make in
            make.top.right.equalTo(view)
            make.height.width.equalTo(50)
        }
    }

    func closeButtonDown() {
        dismiss(animated: true, completion: nil)
    }

    func imageViewController(index: Int) -> ImageViewController {
        let ivc =  ImageViewController()
        ivc.parentView = pageViewController.view
        ivc.imageIndex = index
        ivc.imageName = images[index]
        return ivc
    }
}

class ImageViewController: UIViewController {
    var imageName: String!
    var imageIndex = 0
    var imageView: UIImageView!
    var parentView: UIView!

    override func viewDidLoad() {
        imageView = UIImageView()
        view.addSubview(imageView)
        imageView.frame = CGRect(x: parentView.frame.minX,
                                 y: parentView.frame.minY,
                                 width: parentView.frame.width,
                                 height: parentView.frame.height - 50)
        imageView.contentMode = .scaleAspectFit

        if let imageName = imageName {
            imageView.image = UIImage(named: imageName)
        }
    }
}

extension AboutUsViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? ImageViewController else {
            return nil
        }
        guard vc.imageIndex != 0 else {
            return nil
        }
        currentIndex = vc.imageIndex - 1
        return imageViewController(index: currentIndex)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? ImageViewController else {
            return nil
        }
        guard vc.imageIndex + 1 < images.count else {
            return nil
        }
        currentIndex = vc.imageIndex + 1
        return imageViewController(index: currentIndex)
    }

}
