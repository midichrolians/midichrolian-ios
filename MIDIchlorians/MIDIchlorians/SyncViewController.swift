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
    private var spinnerView: UIActivityIndicatorView!
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

        spinnerView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinnerView.hidesWhenStopped = true
        view.addSubview(spinnerView)

        // add listener for sync completion
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handle(notification:)),
            name: NSNotification.Name(rawValue: Config.cloudNotificationKey),
            object: nil)

        setConstraints()
    }

    func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        spinnerView.snp.makeConstraints { make in
            make.edges.equalTo(view).inset(20)
        }
    }

    func onUpload() {
        if DropboxClientsManager.authorizedClient == nil {
            delegate?.loadDropboxWebView()
        } else {
            animateSyncStart()
            CloudManager.instance.saveToDropbox()
        }
        dismiss(animated: true, completion: nil)
    }

    func onDownload() {
        if DropboxClientsManager.authorizedClient == nil {
            delegate?.loadDropboxWebView()
        } else {
            animateSyncStart()
            CloudManager.instance.loadFromDropbox()
        }
        dismiss(animated: true, completion: nil)
    }

    func animateSyncStart() {
        upload.isEnabled = false
        download.isEnabled = false
        spinnerView.startAnimating()
    }

    func handle(notification: Notification) {
        spinnerView.stopAnimating()
        upload.isEnabled = true
        download.isEnabled = true
    }

}
