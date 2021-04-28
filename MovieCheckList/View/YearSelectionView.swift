//
//  YearSelectionView.swift
//  MovieCheckList
//
//  Created by Steven Lin on 2020/9/4.
//  Copyright © 2020 Steven Lin. All rights reserved.
//

import UIKit

protocol CloseViewDelegate{
    func close(year: Int)
}

class YearSelectionView: UIView {

    @IBOutlet weak var yearTextField: UITextField!
    fileprivate weak var playerNibView: UIView!

    var delegate: CloseViewDelegate?
    var nowYear: Int?
    var chooseYear = 0
    var yearOffset = 0
    
    init(frame: CGRect, vc: MovieListViewController, currentYear: Int, nowYear: Int) {
        super.init(frame: frame)

        self.delegate = vc
        loadViewFromNib()
        yearTextField.text = String(currentYear)
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        chooseYear = currentYear
        self.nowYear = nowYear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        loadViewFromNib()
    }
    
    func loadViewFromNib(){
         let addInfoView: UIView = UINib.loadYearSelectionView(self)
         self.addSubview(addInfoView)
         self.playerNibView = addInfoView
    }
    
    @IBAction func nextYear(_ sender: UIButton) {
        guard let cYear = nowYear else { return }
        if chooseYear < cYear{
            chooseYear += 1
            yearTextField.text = String(chooseYear)
        }else{
            yearTextField.blink()
        }
    }
    
    @IBAction func previousYear(_ sender: UIButton) {
        chooseYear -= 1
        yearTextField.text = String(chooseYear)
    }
    
    @IBAction func sendYear(_ sender: UIButton) {
        delegate?.close(year: chooseYear)
    }
}
