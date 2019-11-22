//
//  UIViewController+Extensions.swift
//  ChatUI
//
//  Created by Ryan on 11/11/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import UIKit

extension UIViewController {
    func showMessageAlert(message: String, completion: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
        present(alert, animated: true, completion: nil)
    }
    
    func showConfirmAlert(title: String, message: String?, completion: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
