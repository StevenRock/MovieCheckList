//
//  DetailSegmentsViewController.swift
//  MovieCheckList
//
//  Created by Steven Lin on 2021/3/4.
//  Copyright © 2021 Steven Lin. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import Lottie

protocol ForCastDelegate: class{
   func setCastDatas(id: Int)
}

protocol ForPosterDelegate: class{
   func getPicString(strImg: String)
}

protocol ForDetailDelegate: class{
   func getOverview(content: (overview: String, release: String, avg: Double,
                    id: Int, imgPath: String, title: String))
}

protocol ForTrailerDelegate: class{
   func getVideoName(name: String)
}

class DetailSegmentsViewController: UIViewController {
   
   @IBOutlet weak var typeSegments: UISegmentedControl!
   @IBOutlet weak var mainView: UIView!
   @IBOutlet weak var bgImageView: UIImageView!
   @IBOutlet weak var saveButton: UIButton!
   
   var viewModel: DetailDegmentViewModelProtocol?
   
   weak var castDelegate: ForCastDelegate?
   weak var posterDelegate: ForPosterDelegate?
   weak var detailDelegate: ForDetailDelegate?
   weak var trailerDelegate: ForTrailerDelegate?
   
   var containViewsArr = [UIViewController]()
   let briefVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BriefInfoViewController") as! BriefInfoViewController
   let posterVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PosterViewController") as! PosterViewController
   let castTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CastTableViewController") as! CastTableViewController
   let trailerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TrailerViewController") as! TrailerViewController
   
   var animationView: AnimationView?{
      didSet{
        setAnimationView()
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setSegmentUI()
      addChildView(vc: briefVC)
   }
   
   override func viewWillAppear(_ animated: Bool) {
      animationView = AnimationView(name: "34590-movie-theatre")
      bgImageView.image = UIImage(named: "theater")
      typeSegments.selectedSegmentIndex = 0
      
      changeSeg(sender: typeSegments)
      setSaveButton()
   }
   
   override func viewDidAppear(_ animated: Bool) {
      binding()
   }
   
   override func viewDidDisappear(_ animated: Bool) {
      navigationItem.title = ""
   }
   
   fileprivate func binding(){
      guard let viewModel = viewModel else { return }
      
      viewModel.id.bindAndFire { [unowned self] in
         self.castDelegate?.setCastDatas(id: $0)
      }
      viewModel.title.bindAndFire { [unowned self] in
         navigationItem.title = $0
         self.trailerDelegate?.getVideoName(name: $0)
      }
      viewModel.poster_path.bindAndFire { [unowned self] in
         self.posterDelegate?.getPicString(strImg: $0)
         self.setBg(path: $0)
      }
      viewModel.briefInfo.bindAndFire { [unowned self] in
         self.detailDelegate?.getOverview(content: $0)
      }
      
      animationView?.removeFromSuperview()
   }
   
   private func setAnimationView(){
      
      animationView?.frame = CGRect(x: 0, y: 0, width: 350, height: 350)
      animationView?.center = self.view.center
      animationView?.contentMode = .scaleAspectFill
      animationView?.loopMode = .repeatBackwards(1)
      animationView?.animationSpeed = 6
      
      view.addSubview(animationView!)
      animationView?.play()
   }
   
   private func setSegmentUI(){
      typeSegments.backgroundColor = UIColor(red: 15/255, green: 37/255, blue: 64/255, alpha: 1)
      if #available(iOS 13.0, *) {
         typeSegments.selectedSegmentTintColor = UIColor(red: 0, green: 98/255, blue: 132/255, alpha: 1)
      } else {
         typeSegments.tintColor = UIColor(red: 0, green: 98/255, blue: 132/255, alpha: 1)
      }
      typeSegments.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
      
      typeSegments.addTarget(self, action: #selector(changeSeg(sender:)), for: .valueChanged)
   }
   
   private func setSaveButton(){
      guard let title = viewModel?.title.value else { return }
      
      guard let isSaved = viewModel?.checkIfInfoIsSaved(title: title) else{ return }
      let str = (!isSaved) ? "heart_no" : "heart"
      saveButton.setImage(UIImage(named: str), for: .normal)
   }
   
   private func setContainView(){
      self.castDelegate = castTableVC
      self.posterDelegate = posterVC
      self.detailDelegate = briefVC
      self.trailerDelegate = trailerVC
      
      setContainViewArr(vcs: [briefVC, castTableVC, posterVC, trailerVC])
   }
   
   @IBAction func saveToList(_ sender: UIButton) {
      let isWatched = false
      let recommand = "notyet"
//      MARK: TODO
      guard let title = viewModel?.title.value,
            let poster = viewModel?.poster_path.value,
            let isSuccess = viewModel?.saveUserDefault(title: title, strImg: poster, strRecommand: recommand, isWatched: isWatched, date: "", review: "", movieID: 0) else { return }
      
      if isSuccess{
         saveButton.setImage(UIImage(named: "heart"), for: .normal)
         buttonAnimate()
         print("Saved!")
      }else{
         print("already saved")
         let alertController = UIAlertController(title: "Hey!", message: "You've already saved this movie!\nGo check this out!", preferredStyle: .alert)
         let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(action)
         
         present(alertController, animated: true, completion: nil)
      }
   }
   
   private func buttonAnimate(){
      saveButton.transform = CGAffineTransform(scaleX: 0, y: 0)
      UIView.animate(withDuration: 0.4, delay: 0, options: [.curveLinear]) {
         self.saveButton.transform = CGAffineTransform(scaleX: 2, y: 2)
      } completion: { (_) in
         UIView.animate(withDuration: 0.1, delay: 0.1, options: [.curveLinear]) {
            self.saveButton.transform = .identity
         } completion: { (_) in
         }
      }
   }
   
   private func setBg(path: String){
         let url = URL(string: "\(Addr.picAddr)\(path)")
         bgImageView.kf.indicatorType = .activity
         
         let placeHolder_img = UIImage(named: path)
         bgImageView.kf.setImage(with: url, placeholder: placeHolder_img)
   }
   
   private func setContainViewArr(vcs: [UIViewController]){
      vcs.forEach {
         containViewsArr.append($0)
      }
   }
   
   @objc private func changeSeg(sender: UISegmentedControl){
      containViewsArr.forEach {$0.view.removeFromSuperview()}
      
      let selectVC = containViewsArr[sender.selectedSegmentIndex]
      addChildView(vc: selectVC)
   }
   
   private func addChildView(vc: UIViewController){
      addChild(vc)
      mainView.addSubview(vc.view)
      vc.view.snp.makeConstraints { (make) in
         make.edges.equalTo(mainView)
      }
      vc.didMove(toParent: self)
   }
}

extension DetailSegmentsViewController: GetData{
   func receiveData(data: MovieData) {
      viewModel = DetailDegmentViewModel(data: data)
      setContainView()
   }
}
