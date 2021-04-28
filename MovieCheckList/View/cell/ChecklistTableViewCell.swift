//
//  ChecklistTableViewCell.swift
//  MovieCheckList
//
//  Created by Steven Lin on 2020/9/10.
//  Copyright © 2020 Steven Lin. All rights reserved.
//

import UIKit

class ChecklistTableViewCell: UITableViewCell {

    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var recommandImg: UIImageView!
    @IBOutlet weak var isWatchedLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(title: String, strImg: String, strRecommand: String, isWatched: Bool){
        titleLabel.text = title
        recommandImg.image = UIImage(named: strRecommand)
        isWatchedLabel.text = isWatched ? "Watched":"Waiting"
        
        let url = URL(string: "\(Addr.picAddr)\(strImg)")
        postImg.kf.indicatorType = .activity
        let placeHolder_img = UIImage(named: strImg)
        postImg.kf.setImage(with: url, placeholder: placeHolder_img)
    }
    
    func setRecommand(strRecommand: String){
        recommandImg.image = UIImage(named: strRecommand)
    }
}

