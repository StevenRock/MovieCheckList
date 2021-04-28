//
//  TipView.swift
//  WantToWatchMovie
//
//  Created by Steven Lin on 2021/4/15.
//  Copyright © 2021 Steven Lin. All rights reserved.
//

import UIKit

class TipView: UIView {

    @IBOutlet weak var tipButton: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib(frame: frame)
        tipButton.layer.cornerRadius = 10
//        self.cornerRadius = 50
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func loadViewFromNib(frame: CGRect){
        let addInfoView: UIView = UINib.loadTipView(self)
        addInfoView.frame = frame
        self.addSubview(addInfoView)
   }
    
    @IBAction func close(_ sender: Any) {
        self.removeFromSuperview()
    }
    
}
