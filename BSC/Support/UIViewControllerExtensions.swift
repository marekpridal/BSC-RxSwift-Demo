//
//  UIViewControllerExtensions.swift
//  BSC
//
//  Created by Marek Pridal on 25.05.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    var content: UIViewController {
        if let navVC = self as? UINavigationController {
            return navVC.visibleViewController ?? self
        }else {
            return self
        }
    }
}
