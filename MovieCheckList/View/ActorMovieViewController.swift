//
//  ActorMovieViewController.swift
//  WantToWatchMovie
//
//  Created by Steven Lin on 2021/4/12.
//  Copyright © 2021 Steven Lin. All rights reserved.
//

import UIKit
import Kingfisher

class ActorMovieViewController: UIViewController {

    @IBOutlet weak var listCollectionView: UICollectionView!
    @IBOutlet weak var listCollectionLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var actorImage: UIImageView!
    
    weak var delegate: GetData?
    
    var imgPath: String?
    var viewModel: ActorMovieViewModelProtocol?{
        didSet{
            binding()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.fetchListData()
        
        if let imgPath = imgPath{
            setUI(path: imgPath)
        }
    }
    
    fileprivate func binding(){
        viewModel?.apiResults.bindAndFire({[unowned self] _ in
            DispatchQueue.main.async {
                self.listCollectionView.reloadData()
            }
        })
        
        viewModel?.actorTitle.bindAndFire({[unowned self] in
            self.navigationItem.title = $0
        })
        
        viewModel?.strImgPath.bindAndFire({[unowned self] in
            imgPath = $0
        })
    }
    
    private func setLayout(){
        let fullScreenSize = UIScreen.main.bounds.size
        
        listCollectionLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        listCollectionLayout.itemSize = CGSize(width: fullScreenSize.width/2-10, height: 300)
        listCollectionLayout.minimumLineSpacing = 5
        listCollectionLayout.scrollDirection = .vertical
    }
    
    private func setUI(path: String){
        let url = URL(string: "\(Addr.picAddr)\(path)")
        actorImage.kf.indicatorType = .activity
        let placeHolder_img = UIImage(named: path)
        actorImage.kf.setImage(with: url, placeholder: placeHolder_img)
    }
}

extension ActorMovieViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = viewModel?.apiResults.value.count else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ListCollectionViewCell
        let movieUnit = viewModel?.apiResults.value[indexPath.row]
        
        if let title = movieUnit?.title{
            cell.setCell(strTitle: title, picAddr: movieUnit?.poster_path)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == collectionView.numberOfSections - 1 &&
            indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1{
            viewModel?.fetchNextPageData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let segVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailSegmentsViewController") as! DetailSegmentsViewController
        self.delegate = segVC
        
        if let val = viewModel?.apiResults.value[indexPath.row]{
            delegate?.receiveData(data: val)
            navigationController?.pushViewController(segVC, animated: true)
        }
    }
}

extension ActorMovieViewController: RecieveActorIDDelegate{
    func recieveID(id: Int, name: String, img: String) {
        viewModel = ActorMovieViewModel(id: id, name: name, imgPath: img)
    }
}
