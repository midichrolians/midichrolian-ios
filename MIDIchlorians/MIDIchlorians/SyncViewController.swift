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

// Manages the ui for sync (upload and download) to dropbox
class SyncViewController: UIViewController {
    private var loginout: UIButton = UIButton(type: .system)
    private var upload: UIButton = UIButton(type: .system)
    private var download: UIButton = UIButton(type: .system)
    private var stackView: UIStackView = UIStackView()
    private var spinnerView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    weak var delegate: SyncDelegate?
    private var isLoggedIn: Bool {
        return DropboxClientsManager.authorizedClient != nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        buildViewHierarchy()
        setUp()
        setUpTargetAction()
        addNotificationHandler()
        setConstraints()
    }

    func buildViewHierarchy() {
        stackView.addArrangedSubview(loginout)
        stackView.addArrangedSubview(upload)
        stackView.addArrangedSubview(download)
        view.addSubview(stackView)
        view.addSubview(spinnerView)
    }

    func setUp() {
        if isLoggedIn {
            loginout.setTitle(Config.topNavLoginTitle, for: .normal)
        } else {
            loginout.setTitle(Config.topNavLogoutTitle, for: .normal)
        }

        upload.setTitle(Config.topNavSyncUploadTitle, for: .normal)

        download.setTitle(Config.topNavSyncDownloadTitle, for: .normal)

        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center

        self.preferredContentSize = CGSize(width: Config.topNavSyncPreferredWidth,
                                           height: Config.topNavSyncPreferredHeight)

        spinnerView.hidesWhenStopped = true
    }

    func setUpTargetAction() {
        loginout.addTarget(self, action: #selector(onLoginout), for: .touchDown)
        upload.addTarget(self, action: #selector(onUpload), for: .touchDown)
        download.addTarget(self, action: #selector(onDownload), for: .touchDown)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isLoggedIn {
            loginout.setTitle(Config.topNavLogoutTitle, for: .normal)
            loginout.isEnabled = !spinnerView.isAnimating
            upload.isEnabled = !spinnerView.isAnimating
            download.isEnabled = !spinnerView.isAnimating
        } else {
            loginout.setTitle(Config.topNavLoginTitle, for: .normal)
            upload.isEnabled = false
            download.isEnabled = false
        }
    }

    func addNotificationHandler() {
        // add listener for sync completion
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handle(notification:)),
            name: NSNotification.Name(rawValue: Config.cloudNotificationKey),
            object: nil)
    }

    func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        spinnerView.snp.makeConstraints { make in
            make.edges.equalTo(view).inset(Config.topNavSyncSpinnerInset)
        }
    }

    func onLoginout() {
        if isLoggedIn {
            DropboxClientsManager.unlinkClients()
            viewWillAppear(true)
        } else {
            dismiss(animated: true, completion: {
                self.delegate?.loadDropboxWebView()
            })
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
