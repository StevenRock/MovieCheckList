//
//  UINib+Loader.swift
//  MVVMSwiftExample
//
//  Created by Dino Bartosak on 26/09/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit

fileprivate extension UINib {
    
    static func nib(named nibName: String) -> UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
    
    static func loadSingleView(_ nibName: String, owner: Any?) -> UIView {
        return nib(named: nibName).instantiate(withOwner: owner, options: nil)[0] as! UIView
    }
}

// MARK: App Views

extension UINib {
    class func loadYearSelectionView(_ owner: AnyObject) -> UIView {
        return loadSingleView("YearSelectionView", owner: owner)
    }
    
    class func loadEditReviewView(_ owner: AnyObject) -> UIView{
        return loadSingleView("EditReviewView", owner: owner)
    }
    
    class func loadTipView(_ owner: AnyObject) -> UIView{
        return loadSingleView("TipView", owner: owner)
    }
}
