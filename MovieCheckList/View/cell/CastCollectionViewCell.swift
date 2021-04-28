//
//  CastCollectionViewCell.swift
//  MovieCheckList
//
//  Created by Steven Lin on 2020/9/9.
//  Copyright © 2020 Steven Lin. All rights reserved.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var castImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    
    func setCell(strImg: String?, name: String, character: String) {
        nameLabel.text = name
        characterLabel.text = character
        
        let url = URL(string: "\(Addr.picAddr)\(strImg ?? "00000")")
        castImg.kf.indicatorType = .activity
        let placeHolder_img = UIImage(named: "question")
        castImg.kf.setImage(with: url, placeholder: placeHolder_img)
    }
}
