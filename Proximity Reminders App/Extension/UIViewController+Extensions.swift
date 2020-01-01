//
//  UIViewController+Extensions.swift
//  Proximity Reminders App
//
//  Created by Arwin Oblea on 12/30/19.
//  Copyright © 2019 Arwin Oblea. All rights reserved.
//

import UIKit

extension UIViewController {

  func presentAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let alert = UIAlertAction(title: "OK", style: .default, handler: nil)
    
    alertController.addAction(alert)
    
    self.present(alertController, animated: true)
  }
  
}
