//
//  ChecklistViewController.swift
//  MovieCheckList
//
//  Created by Steven Lin on 2020/9/10.
//  Copyright © 2020 Steven Lin. All rights reserved.
//

import UIKit

//protocol SetReviewInfoProtocol: class{
//    func recieveData(data: UserMovie, title: String, strImg: String, strRecommand: String)
//}
class ChecklistViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    
    var coreArr = [UserMovie]()
    
    var editReviewView: EditReviewView?
    var blurEffectView = UIVisualEffectView()
//    var delegate: SetReviewInfoProtocol?
    var viewModel: ChecklistViewModelProtocol?{
        didSet{
            binding()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel = ChecklistViewModel()
    }
    
    private func binding(){
        viewModel?.coreArr.bindAndFire{ [unowned self] in
            coreArr = $0
            listTableView.reloadData()
        }
    }
    
    func editCore(data: UserMovie, strRecommand: String?, isEdit: Bool){
        presentEditReviewView(data: data, strRecommand: strRecommand, isEdit: isEdit)
//TODO
//        viewModel?.editCoreData(userMovie: data, title: title, strImg: strImg, strRecommand: strRecommand, isWatched: true, date: "", review: "", movieID: 0)
    }
    
    private func presentEditReviewView(data: UserMovie, strRecommand: String?, isEdit: Bool){
        editReviewView = EditReviewView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 0.8, height: self.view.frame.height * 0.5), vc: self, coreData: data, strRecommand: strRecommand, isEdit: isEdit)
        //        self.delegate = EditReviewViewModel
        UIView.transition(with: self.view, duration: 0.5, options: [.transitionCurlDown],animations: { [self] in
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeEffectView))
            let blurEffect = UIBlurEffect(style: .light)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.addGestureRecognizer(tapGesture)
            self.view.addSubview(blurEffectView)
            
            self.view.addSubview(self.editReviewView!)
            editReviewView!.center  = self.view.center
        }, completion: nil) //{ (<#Bool#>) in
//            <#code#>
//        }
    }
    
    @objc func closeEffectView(){
        UIView.transition(with: self.view, duration: 0.5, options: [.transitionCurlUp],animations: { [self] in
            editReviewView?.removeFromSuperview()
            blurEffectView.removeFromSuperview()
        }, completion: {_ in 
            self.viewModel?.fetch()
        })
    }
}

extension ChecklistViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChecklistTableViewCell
        
        let data = coreArr[indexPath.row]
        cell.setCell(title: data.title!, strImg: data.strImg!, strRecommand: data.strRecommand!, isWatched: data.isWatched)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {return}
        if editingStyle == .delete{
            viewModel.deleteCoreData(data: coreArr[indexPath.row])
        }
    }
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let data = coreArr[indexPath.row]

        let soGoodAction = UIContextualAction(style: .normal, title: "So Good!") { (acrtion, view, completionHandler) in
            print("so good")
            self.editCore(data: data, strRecommand: "sogood", isEdit: true)
            completionHandler(true)
        }
        
        let goodAction = UIContextualAction(style: .normal, title: "Good!") { (acrtion, view, completionHandler) in
            print("good")
            self.editCore(data: data, strRecommand: "good", isEdit: true)

            completionHandler(true)
        }
        
        let sosoAction = UIContextualAction(style: .normal, title: "So So") { (acrtion, view, completionHandler) in
            print("so so")
            self.editCore(data: data, strRecommand: "soso", isEdit: true)

            completionHandler(true)
        }
        
        let badAction = UIContextualAction(style: .normal, title: "Bad!") { (acrtion, view, completionHandler) in
            print("bad")
            self.editCore(data: data, strRecommand: "bad", isEdit: true)

            completionHandler(true)
        }
        
        let soBadAction = UIContextualAction(style: .normal, title: "So Bad!") { (acrtion, view, completionHandler) in
            print("so bad")
            self.editCore(data: data, strRecommand: "sobad", isEdit: true)

            completionHandler(true)
        }
        
        soGoodAction.backgroundColor = .systemRed
        goodAction.backgroundColor = .orange
        sosoAction.backgroundColor = .cyan
        badAction.backgroundColor = .gray
        soBadAction.backgroundColor = .darkGray
        
        let configuration = UISwipeActionsConfiguration(actions: [soGoodAction, goodAction, sosoAction, badAction, soBadAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = coreArr[indexPath.row]
        editCore(data: data, strRecommand: nil, isEdit: false)
    }
}

extension ChecklistViewController:CloseReviewViewDelegate{
    func close() {
        closeEffectView()
    }
}
