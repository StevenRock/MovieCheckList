//
//  CastTableViewController.swift
//  MovieCheckList
//
//  Created by Steven Lin on 2021/3/4.
//  Copyright © 2021 Steven Lin. All rights reserved.
//

import UIKit

protocol RecieveActorIDDelegate{
    func recieveID(id: Int, name: String, img: String)
}

class CastTableViewController: UITableViewController {

    var castArr = [CastData]()
    var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    var delegate: RecieveActorIDDelegate?
    
    let actorVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ActorMovieViewController") as! ActorMovieViewController
    
    var viewModel: CastTableViewModelProtocol?{
        didSet{
            binding()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = actorVC
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.register(UINib(nibName: "CastTableViewCell", bundle: nil), forCellReuseIdentifier: "CastTableViewCell")
        selectedIndex = IndexPath(row: 0, section: 0)

        if castArr.count != 0{
            spinTableView()
        }else{
            noDataAlertView()
        }
        self.tableView.reloadData()
    }
    
    fileprivate func binding(){
        guard let viewModel = viewModel else {return}
        viewModel.castInfos.bindAndFire { [unowned self] in
            castArr = $0
            self.tableView.reloadData()
        }
    }
    
    private func noDataAlertView(){
        let alertController = UIAlertController(title: "Ooops", message: "There is no cast list so far..", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func spinTableView(){
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return castArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CastTableViewCell", for: indexPath) as! CastTableViewCell
        
        if let actor = castArr[indexPath.row].name,
           let role = castArr[indexPath.row].character{
            cell.setCell(imageName: castArr[indexPath.row].profile_path,
                          actorName: actor,
                          roleName: role)
        }else{
            
        }


        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath{
            return 500
        }else{
            return 45
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex == indexPath{
            guard let id = castArr[indexPath.row].id, let name = castArr[indexPath.row].name else {return}
            delegate?.recieveID(id: id, name: name, img: castArr[indexPath.row].profile_path ?? "question")
            navigationController?.pushViewController(actorVC, animated: true)
            
        }else{
            selectedIndex = indexPath
            
            tableView.beginUpdates()
            tableView.reloadRows(at: [selectedIndex], with: .none)
            tableView.endUpdates()
            
        }
        tableView.reloadData()
    }

}

extension CastTableViewController: ForCastDelegate{
    func setCastDatas(id: Int) {
        viewModel = CastTableViewModel(with: id)
        viewModel?.fetchCastData()
    }
    
    
}
