//
//  TrailerViewController.swift
//  WantToWatchMovie
//
//  Created by Steven Lin on 2021/3/29.
//  Copyright © 2021 Steven Lin. All rights reserved.
//

import UIKit
import WebKit

class TrailerViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var youtubeWebView: WKWebView!
    
    var viewModel: TrailerViewModelProtocol?{
        didSet{
            binding()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//https://image.tmdb.org/t/p/w500/iopYFB1b6Bh7FWZh3onQhph1sih.jpg
        // Do any additional setup after loading the view.
    }
    private func binding(){
//        viewModel?.videoID.bindAndFire{[unowned self] in
//            print($0)
//        }
        viewModel?.embededStr.bindAndFire{[unowned self] in
            youtubeWebView.navigationDelegate = self
            youtubeWebView.loadHTMLString($0, baseURL: nil)
        }
    }
}

extension TrailerViewController: ForTrailerDelegate{
    func getVideoName(name: String) {
        viewModel = TrailerViewModel()
        viewModel?.fetchVideoData(name: name)
    }
}
