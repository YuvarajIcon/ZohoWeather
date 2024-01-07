//
//  BaseViewController.swift
//  ZohoWeather
//
//  Created by Yuvaraj Selvam on 07/01/24.
//

import Foundation
import UIKit

/**
 BaseViewController

 A custom base class for view controllers providing common functionality.
 */
class BaseViewController: UIViewController {
    
/**
     Presents a simple alert with an "Okay" action button.

     - Parameters:
        - title: The title of the alert.
        - message: The message displayed in the alert.
     */
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okayAction)
        present(alertController, animated: true, completion: nil)
    }
    
/**
     Presents an alert with a text field, "Cancel" and "Okay" action buttons.

     - Parameters:
        - title: The title of the alert.
        - message: The message displayed in the alert.
        - placeholder: The placeholder text for the text field.
        - defaultValue: The default value to pre-fill in the text field.
        - completion: A closure that is called with the entered text when the user taps "Okay" or `nil` when the user taps "Cancel".
     */
    func presentTextFieldAlert(
            title: String?,
            message: String?,
            placeholder: String?,
            defaultValue: String?,
            completion: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = placeholder
            textField.text = defaultValue
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            completion(nil)
        })

        let okAction = UIAlertAction(title: "Okay", style: .default) { _ in
            let text = alertController.textFields?.first?.text
            completion(text)
        }

        alertController.addAction(cancelAction)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
}
