//
//  ListCollectionViewCell.swift
//  MovieCheckList
//
//  Created by Steven Lin on 2020/9/1.
//  Copyright © 2020 Steven Lin. All rights reserved.
//

import UIKit
import Kingfisher

class ListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setCell(strTitle: String, picAddr: String?) {
        titleLabel.text = strTitle
        
        let url = URL(string: "\(Addr.picAddr)\(picAddr ?? "12345")")
        movieImg.kf.indicatorType = .activity
        let placeHolder_img = UIImage(named: "question")
        movieImg.kf.setImage(with: url, placeholder: placeHolder_img)
    }
}
