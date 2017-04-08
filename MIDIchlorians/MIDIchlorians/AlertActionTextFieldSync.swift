//
//  AlertActionTextFieldSync.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 8/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation
import UIKit

// Synchronizes the enabled state of an alert action with a text field's contents
class AlertActionTextFieldSync: NSObject, UITextFieldDelegate {
    private var alertAction: UIAlertAction
    init(alertAction: UIAlertAction) {
        self.alertAction = alertAction
        super.init()
    }

    // Don't allow return if the field is empty, user must explicitly cancel
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return !(textField.text?.isEmpty ?? true)
    }

    // Deactivate the Save button if text field is empty
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }

        let str = (text as NSString).replacingCharacters(in: range, with: string)
        if str.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
            alertAction.isEnabled = false
        } else {
            alertAction.isEnabled = true
        }
        return true
    }

}
