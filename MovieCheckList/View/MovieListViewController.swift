//
//  MovieListViewController.swift
//  MovieCheckList
//
//  Created by Steven Lin on 2020/9/1.
//  Copyright © 2020 Steven Lin. All rights reserved.
//

import UIKit
import Lottie

protocol GetData: class {
    func receiveData(data: MovieData)
}

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var listCollectionView: UICollectionView!
    @IBOutlet weak var listCollectionLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var yearBtn: UIBarButtonItem!
    @IBOutlet weak var pageButton: UIButton!
    
    var cancelBarItem: UIBarButtonItem!
    var titleButton: UIButton!
    var genreStr: String?
    
    var TypeVC = TypeViewController()
    
    var viewModel: DataFetchViewModelProtocol?{
        didSet{
            binding()
        }
    }
    
    let fullScreenSize = UIScreen.main.bounds.size
    fileprivate var pageNum: Int = 1
    fileprivate var nowYearNum: Int?
    fileprivate var query = String()
    var blurEffectView = UIVisualEffectView()
    var addYearSelectionView: YearSelectionView?
    var searchController: UISearchController?
    
    weak var delegate: GetData?
    var segVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailSegmentsViewController") as! DetailSegmentsViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleButton()

        viewModel = DataFetchViewModel()
        setNavigationBar()
//
//        let objTools = ObjcTools()
//        objTools.loader(VC: self)
//        
        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        
        setLayout()
        fetchData()
        
        tipAlertView()
    }
    
    private func tipAlertView(){
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeEffectView))
        
//        let blurEffect = UIBlurEffect(style: .light)
//        blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
////        blurEffectView.addGestureRecognizer(tapGesture)
//        view.addSubview(blurEffectView)
        
        let tipView = TipView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 0.8, height: self.view.frame.height * 0.8))
//        addYearSelectionView = YearSelectionView(frame: CGRect(x: 0, y: 0, width: 298, height: 132), vc: self, currentYear: viewModel.searchYearNum.value, nowYear: nowYear)
        tipView.center = self.view.center
        tipView.layer.cornerRadius = 20
        self.view.addSubview(tipView)
        
    }
    
    private func setNavigationBar(){
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 15/255, green: 37/255, blue: 64/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        cancelBarItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(performCancel))
        navigationItem.leftBarButtonItem = cancelBarItem
        navigationItem.leftBarButtonItem = nil
        
        tabBarController?.tabBar.barTintColor = UIColor(red: 15/255, green: 37/255, blue: 64/255, alpha: 1)
        
        nextBtn.backgroundColor = UIColor(red: 0, green: 92/255, blue: 175/255, alpha: 1)
        previousBtn.backgroundColor = UIColor(red: 11/255, green: 52/255, blue: 110/255, alpha: 1)
        pageButton.setTitleColor(UIColor(red: 8/255, green: 25/255, blue: 45/255, alpha: 1), for: .normal)
    }
    
    fileprivate func binding(){
        viewModel?.apiResults.bindAndFire({ [unowned self] _ in
            DispatchQueue.main.async {
                self.listCollectionView.reloadData()
            }
        })
        
        viewModel?.pageVal.bindAndFire{[unowned self] in
            self.pageButton.setTitle("\($0.page) / \($0.totalPage)", for: .normal)
            pageNum = ($0.page != 0) ? Int($0.page) : 1
            
            previousBtn.isEnabled = ($0.totalPage == 0) ? false : true
            nextBtn.isEnabled = ($0.totalPage == 0) ? false : true
        }
        
        viewModel?.searchYearNum.bindAndFire{[unowned self] in
//            self.navigationItem.title = "\($0) popularity"
            self.titleButton.setTitle("\($0) popularity", for: .normal)
        }
        
        viewModel?.currentYear.bindAndFire{[unowned self] in
            nowYearNum = $0
        }
        
        viewModel?.strSearchType.bindAndFire{[unowned self] in
            guard let searchBar = searchController else {return}

            switch $0{
            case SearchType.popularity.rawValue:
                searchBar.searchBar.placeholder = "Movie Title"
                self.titleButton.setTitle("\(nowYearNum ?? 9999) popularity", for: .normal)
            case SearchType.actor.rawValue:
                searchBar.searchBar.placeholder = "\($0) Ex.Brad Pitt"
                self.titleButton.setTitle("Search \($0)", for: .normal)
            default:
                return
            }
        }
    }
    
    @objc private func performCancel() {
        guard let viewModel = viewModel else {return }
        viewModel.switchSearchType(type: .popularity)
        fetchData()
    }
    
    @IBAction func yearSelection(_ sender: Any) {
        yearBtn.isEnabled = false
        guard let viewModel = viewModel, let nowYear = nowYearNum else { return }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeEffectView))
        
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.addGestureRecognizer(tapGesture)
        view.addSubview(blurEffectView)
        
        addYearSelectionView = YearSelectionView(frame: CGRect(x: 0, y: 0, width: 298, height: 132), vc: self, currentYear: viewModel.searchYearNum.value, nowYear: nowYear)
        addYearSelectionView?.center = self.view.center
        self.view.addSubview(addYearSelectionView!)
    }
    
    @IBAction func goPreviousPage(_ sender: UIButton) {
        pageNum -= 1
        
        if pageNum == 0 {
            pageNum = 1
            pageButton.blink()
        }else{
            switch viewModel?.strSearchType.value {
            case SearchType.popularity.rawValue:
                fetchData()
            default:
                fetchSearchData(page: pageNum, name: query)
            }
        }
    }
    
    @IBAction func goNextPage(_ sender: UIButton) {
        guard let totalPage = viewModel?.pageVal.value.totalPage else {return }
//        guard  else {return}
        pageNum += 1
        if pageNum > totalPage{
            pageNum = Int(totalPage)
            pageButton.blink()
        }else{
            switch viewModel?.strSearchType.value {
            case SearchType.popularity.rawValue:
                fetchData()
            default:
                fetchSearchData(page: pageNum, name: query)
            }
        }
    }
    
    @objc func closeEffectView(){
        addYearSelectionView?.removeFromSuperview()
        blurEffectView.removeFromSuperview()
        yearBtn.isEnabled = true
        
        nextBtn.isEnabled = true
        previousBtn.isEnabled = true
    }
    
    @objc func changeType(){
        let actionSheet = UIAlertController(title: "Which type do you want to search for?", message: "", preferredStyle: .actionSheet)
        for item in SearchType.allCases{
            if item != SearchType.movieTitle{
                let action = UIAlertAction(title: item.rawValue, style: .default) { (act) in
                    guard let viewModel = self.viewModel else {return }
                    viewModel.switchSearchType(type: item)
                }
                actionSheet.addAction(action)
            }
        }
        present(actionSheet, animated: true) {
            
        }

    }
    
    func setLayout(){
        listCollectionLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        listCollectionLayout.itemSize = CGSize(width: fullScreenSize.width/2-10, height: 300)
        listCollectionLayout.minimumLineSpacing = 5
        listCollectionLayout.scrollDirection = .vertical
        listCollectionLayout.headerReferenceSize = CGSize(width: fullScreenSize.width, height: 20)
        
        previousBtn.layer.cornerRadius = 15
        nextBtn.layer.cornerRadius = 15
//        setLeftNavigationItem()
    }
    
    func setSearchBar(){
        searchController = UISearchController(searchResultsController: nil)
        guard let searchBar = searchController else {return}

        searchBar.searchBar.tintColor = UIColor(red: 0, green: 98/255, blue: 132/255, alpha: 1)
        searchBar.searchBar.placeholder = "Movie Title"
        searchBar.searchBar.frame.size.width = fullScreenSize.width
        searchBar.searchResultsUpdater = self
        searchBar.searchBar.delegate = self
    }
    
    private func setTitleButton(){
        titleButton = UIButton(type: .custom)
        titleButton.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        titleButton.setTitleColor(.cyan, for: .normal)
        titleButton.setTitleColor(.systemBlue, for: .highlighted)
        titleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        titleButton.setTitle("Button", for: .normal)
        titleButton.addTarget(self, action: #selector(changeType), for: .touchUpInside)
        navigationItem.titleView = titleButton
    }
}

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UISearchResultsUpdating{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let strSearchBar = searchController?.searchBar.text else {return}
        if viewModel?.strSearchType.value == SearchType.popularity.rawValue{
            viewModel?.switchSearchType(type: .movieTitle)
        }
        fetchSearchData(page: nil, name: strSearchBar)
        
//        navigationItem.title = "Result: \(searchController.searchBar.text!)"
        titleButton.setTitle("Result: \(strSearchBar)", for: .normal)
        query = strSearchBar
        nextBtn.isEnabled = false
        previousBtn.isEnabled = false
        
        navigationItem.leftBarButtonItem = cancelBarItem
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionViewHeader", for: indexPath)
            headerView.backgroundColor = UIColor(red: 15/255, green: 37/255, blue: 64/255, alpha: 1)
            if searchController == nil{
                setSearchBar()
            }
            guard let searchBar = searchController else {return headerView}
            searchBar.searchBar.sizeThatFits(CGSize(width: fullScreenSize.width, height: 50))
            headerView.addSubview(searchBar.searchBar)
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
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
        
        if let imgStr = movieUnit?.poster_path{
            cell.setCell(strTitle: movieUnit?.title ?? "GG", picAddr: imgStr)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate = segVC
        
        if let val = viewModel?.apiResults.value[indexPath.row]{
            delegate?.receiveData(data: val)
            navigationController?.pushViewController(segVC, animated: true)
        }
    }
}

//Data Fetch Related
extension MovieListViewController{
    func fetchData(){
        
        guard let viewModel = viewModel else { return }
        
        viewModel.fetchListData(genre: GlobalGenreStr, page: String(pageNum), year: String(viewModel.searchYearNum.value))
        navigationItem.leftBarButtonItem = nil
    }
    
    func fetchSearchData(page: Int?, name: String){
//        viewModel?.switchSearchType(type: .movieTitle)
        
        if #available(iOS 11.0, *) {
            if let lan = NSLinguisticTagger.dominantLanguage(for: name){
                print("LAN: \(lan)")
            }else{
                print("GGLALA")
            }
        } else {

        }
        
        let strName = name.replacingOccurrences(of: " ", with: "+")
        
        guard let viewModel = viewModel else { return }
        
        switch viewModel.strSearchType.value {
        case SearchType.movieTitle.rawValue:
            viewModel.fetchSearchResultdata(page: page, name: strName)
        case SearchType.actor.rawValue:
            viewModel.fetchSearchPersonResultData(page: page, name: strName)
        default:
            return
        }
    }
}

extension MovieListViewController: CloseViewDelegate{
    func close(year: Int) {
        viewModel?.searchYearNum.value = year
        fetchData()
        closeEffectView()
    }
}
