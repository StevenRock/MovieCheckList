//
//  PosterViewController.swift
//  MovieCheckList
//
//  Created by Steven Lin on 2021/3/4.
//  Copyright © 2021 Steven Lin. All rights reserved.
//

import UIKit

class PosterViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    
    var viewModel: PosterViewModelProtocol?{
        didSet{
            binding()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func binding(){
        viewModel?.strImgName.bindAndFire{ [unowned self] in
            let url = URL(string: "\(Addr.picAddr)\($0)")
            posterImage.kf.indicatorType = .activity

            let placeHolder_img = UIImage(named: $0)
            posterImage.kf.setImage(with: url, placeholder: placeHolder_img)
        }
    }
}

extension PosterViewController: ForPosterDelegate{
    func getPicString(strImg: String) {
        viewModel = PosterViewModel(str: strImg)
    }
    
    
}
