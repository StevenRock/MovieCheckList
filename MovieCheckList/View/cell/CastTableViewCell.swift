//
//  CastTableViewCell.swift
//  MovieCheckList
//
//  Created by Steven Lin on 2021/3/4.
//  Copyright © 2021 Steven Lin. All rights reserved.
//

import UIKit
import Kingfisher

class CastTableViewCell: UITableViewCell {

    @IBOutlet weak var actPicImageView: UIImageView!
    @IBOutlet weak var actorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        actorLabel.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0))
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
    }
    func setCell(imageName: String?, actorName: String, roleName: String){
        actorLabel.text = "\(actorName) As\n\(roleName)"
        actorLabel.backgroundColor = UIColor.gray.withAlphaComponent(0.6)

        let url = URL(string: "\(Addr.picAddr)\(imageName ?? "")")
        actPicImageView.kf.indicatorType = .activity
        let placeHolder_img = UIImage(named: "question")
        actPicImageView.kf.setImage(with: url, placeholder: placeHolder_img)
    }
    
}
