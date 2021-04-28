//
//  BriefInfoViewController.swift
//  MovieCheckList
//
//  Created by Steven Lin on 2021/3/4.
//  Copyright © 2021 Steven Lin. All rights reserved.
//

import UIKit

protocol RecieveMovieIDDelegate{
    func recieveID(id: Int, name: String, img: String)
}

class BriefInfoViewController: UIViewController {

    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var similarButton: UIButton!
    
    var delegate: RecieveMovieIDDelegate?
    
    let similarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SimilarMovieViewController") as! SimilarMovieViewController
    
    var viewModel: BriefInfoViewModelProtocol?{
        didSet{
            binding()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        overviewLabel.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        overviewLabel.textColor = UIColor(red: 15/255, green: 37/255, blue: 64/255, alpha: 1)
        releaseDateLabel.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        releaseDateLabel.textColor = UIColor(red: 15/255, green: 37/255, blue: 64/255, alpha: 1)
        voteAverageLabel.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        voteAverageLabel.textColor = UIColor(red: 15/255, green: 37/255, blue: 64/255, alpha: 1)
        
        similarButton.backgroundColor = UIColor(red: 11/255, green: 52/255, blue: 110/255, alpha: 1)
        similarButton.layer.cornerRadius = 10
        
        self.delegate = similarVC
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        overviewLabel.isHidden = true
        releaseDateLabel.isHidden = true
        voteAverageLabel.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        overviewLabel.isHidden = false
        releaseDateLabel.isHidden = false
        voteAverageLabel.isHidden = false
    }
    private func binding(){

        viewModel?.overviewContent.bindAndFire{[unowned self] in
            overviewLabel.text = $0
        }
        viewModel?.releaseDateContent.bindAndFire{[unowned self] in
            releaseDateLabel.text = $0
        }
        viewModel?.voteAverageContent.bindAndFire{[unowned self] in
            voteAverageLabel.text = $0
        }
    }
    
    @IBAction func goSimilarPage(_ sender: Any) {
        
        guard let data = viewModel?.similarDatas.value else {return}
        delegate?.recieveID(id: data.id, name: data.title, img: data.imgPath)
        navigationController?.pushViewController(similarVC, animated: true)
    }
    
}
extension BriefInfoViewController: ForDetailDelegate{
    func getOverview(content: (overview: String, release: String, avg: Double, id: Int, imgPath: String, title: String)) {
        viewModel = BriefInfoViewModel(data: content)
    }
    
    
//    func getOverview(content: (overview: String, release: String, avg: Double)) {
//        viewModel = BriefInfoViewModel(data: content)
//    }
}
