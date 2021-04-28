//
//  UIView+extension.swift
//  WantToWatchMovie
//
//  Created by Steven Lin on 2021/3/30.
//  Copyright © 2021 Steven Lin. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func blink(){
        self.alpha = 0.2
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear, .autoreverse], animations: {
            self.alpha = 1
        }, completion: nil)
    }
}
