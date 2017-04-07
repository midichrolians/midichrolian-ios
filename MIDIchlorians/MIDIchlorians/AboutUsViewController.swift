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
    var someText = UILabel()
    var closeButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        someText.text = "HELLO WORLD!"
        someText.textColor = UIColor.green
        view.addSubview(someText)

        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeButtonDown), for: .touchDown)
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(UIColor.black, for: .normal)

        setConstraints()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setConstraints() {
        someText.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        closeButton.snp.makeConstraints { make in
            make.top.right.equalTo(view)
            make.height.width.equalTo(50)
        }
    }

    func closeButtonDown() {
        dismiss(animated: true, completion: nil)
    }

}
