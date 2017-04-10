//
//  SyncViewController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 7/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyDropbox

class SyncViewController: UIViewController {
    private var upload: UIButton!
    private var download: UIButton!
    private var stackView: UIStackView!
    weak var delegate: SyncDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        upload = UIButton(type: .system)
        upload.setTitle(Config.TopNavSyncUploadTitle, for: .normal)
        upload.addTarget(self, action: #selector(onUpload), for: .touchDown)

        download = UIButton(type: .system)
        download.setTitle(Config.TopNavSyncDownloadTitle, for: .normal)
        download.addTarget(self, action: #selector(onDownload), for: .touchDown)

        stackView = UIStackView(arrangedSubviews: [upload, download])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center

        view.addSubview(stackView)
        self.preferredContentSize = CGSize(width: Config.TopNavSyncPreferredWidth,
                                           height: Config.TopNavSyncPreferredHeight)

        setConstraints()
    }

    func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }

    func onUpload() {
        if DropboxClientsManager.authorizedClient == nil {
            delegate?.loadDropboxWebView()
        } else {
            CloudManager.instance.saveToDropbox()
        }
        dismiss(animated: true, completion: nil)
    }

    func onDownload() {
        if DropboxClientsManager.authorizedClient == nil {
            delegate?.loadDropboxWebView()
        } else {
            CloudManager.instance.loadFromDropbox()
        }
        dismiss(animated: true, completion: nil)
    }

}
