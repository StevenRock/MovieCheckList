//
//  SimilarMovieViewController.swift
//  WantToWatchMovie
//
//  Created by Steven Lin on 2021/4/15.
//  Copyright © 2021 Steven Lin. All rights reserved.
//

import UIKit
import Kingfisher

class SimilarMovieViewController: UIViewController {

    @IBOutlet weak var originalMovieImage: UIImageView!
    @IBOutlet weak var listCollectionView: UICollectionView!
    @IBOutlet weak var listCollectionLayout: UICollectionViewFlowLayout!
    
    var viewModel: SimilarMovieViewModelProtocol?{
        didSet{
            binding()
        }
    }
    
    var imgPath: String?
    weak var delegate: GetData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.fetchListData()
        
        if let imgPath = imgPath{
            setUI(path: imgPath)
        }
    }
    
    fileprivate func binding(){
        viewModel?.apiResults.bindAndFire{[unowned self] _ in
            DispatchQueue.main.async {
                guard let cv = listCollectionView else {return}
                cv.reloadData()
            }
        }
        
        viewModel?.movieTitle.bindAndFire{[unowned self] in
            self.navigationItem.title = $0
        }
        
        viewModel?.strImgPath.bindAndFire{[unowned self] in
            self.imgPath = $0
        }
    }
    
    fileprivate func setUI(path: String){
        let url = URL(string: "\(Addr.picAddr)\(path)")
        originalMovieImage.kf.indicatorType = .activity
        let placeHolder_img = UIImage(named: path)
        originalMovieImage.kf.setImage(with: url, placeholder: placeHolder_img)
    }
    
    private func setLayout(){
        let fullScreenSize = UIScreen.main.bounds.size
        
        listCollectionLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        listCollectionLayout.itemSize = CGSize(width: fullScreenSize.width/2-10, height: 300)
        listCollectionLayout.minimumLineSpacing = 5
        listCollectionLayout.scrollDirection = .vertical
    }
}

extension SimilarMovieViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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

extension SimilarMovieViewController: RecieveMovieIDDelegate{
    func recieveID(id: Int, name: String, img: String) {
        viewModel = SimilarMovieViewModel(id: id, name: name, imgPath: img)
    }
}
