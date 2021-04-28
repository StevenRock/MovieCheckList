//
//  TypeViewController.swift
//  WantToWatchMovie
//
//  Created by Steven Lin on 2021/4/19.
//  Copyright © 2021 Steven Lin. All rights reserved.
//

import UIKit
import Magnetic

protocol GenreDelegate{
    func recieveGenre(id: String?)
}

class TypeViewController: UIViewController {

    @IBOutlet weak var infLabel: UILabel!
    @IBOutlet weak var goButton: UIButton!
    
    var delegate: GenreDelegate?
    
    @IBOutlet var magView: MagneticView!{
        didSet{
            magnetic?.magneticDelegate = self
            magnetic?.removeNodeOnLongPress = false
        }
    }
    var magnetic: Magnetic?{
        return magView.magnetic
    }
    
    var viewModel: GenreViewModelProtocol?{
        didSet{
            binding()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        viewModel = GenreViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.fetchGenreDatas()
    }
    
    private func binding(){
        viewModel?.genreDatas.bindAndFire{[unowned self] in
            for item in $0{
                let name = item.name
                let color = UIColor(red: 102, green: 153, blue: 161)
                let node = Node(text: name, image: nil, color: color, radius: 40)
                node.scaleToFitContent = true
                node.label.fontColor = .darkGray
                node.selectedColor = UIColor(red: 17, green: 50, blue: 133)
                magnetic?.addChild(node)
            }
        }
        
        viewModel?.chosedGenreDatas.bindAndFire{[unowned self] in
            if $0.count == 0{
                setInfLabel(withGenre: nil)
            }else{
                setInfLabel(withGenre: $0)
            }
        }
    }
    
    @IBAction func goToMovieList(_ sender: UIButton) {
        let tabVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tab") as! UITabBarController
        
//        let listVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "listController") as! MovieListViewController
        tabVC.modalPresentationStyle = .fullScreen
        
//        self.delegate = listVC
        let idArr = viewModel?.chosedGenreDatas.value.compactMap{String($0.id ?? 0)}
        let str = idArr?.joined(separator: ",")
        GlobalGenreStr = str
//        delegate?.recieveGenre(id: str)
        present(tabVC, animated: true, completion: nil)
    }
    
    fileprivate func setUI(){
        magnetic?.backgroundColor = UIColor(red: 86, green: 108, blue: 115)
        goButton.layer.cornerRadius = 30
    }
    
    private func setInfLabel(withGenre genre: [Genres]?){
        infLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        infLabel.textColor = .white
        infLabel.numberOfLines = 0
        infLabel.textAlignment = .center
        
        if let genres = genre{
            let strArr = genres.compactMap{$0.name}
            
            let attrStrArr = strArr.enumerated().map{ index, element in
                return NSAttributedString(string: element, attributes:[NSAttributedString.Key.backgroundColor: UIColor(red: 17, green: 50, blue: 133), NSAttributedString.Key.foregroundColor: UIColor.yellow])
            }
            
            var mutableAttrStr: NSMutableAttributedString{
                let str = NSMutableAttributedString(string: "Your Choice:\n")
                for item in attrStrArr{
                    str.append(NSAttributedString(string: " "))
                    str.append(item)
                }
                return str
            }
            infLabel.attributedText = mutableAttrStr
        }else{
            infLabel.text = "Select your interesting genres, or we will show you the most popular movies of the year!"
        }
    }
}

extension TypeViewController: MagneticDelegate{
    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        guard let genre = node.text else {return }
        print("didSelect -> \(genre)")
        viewModel?.addGenreID(genre: genre)
        
        node.label.fontColor = .yellow
    }
    
    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
        guard let genre = node.text else {return }
        
        print("didDeselect -> \(genre)")
        viewModel?.reduceGenreID(genre: genre)
        
        node.label.fontColor = .darkGray
    }
    
    func magnetic(_ magnetic: Magnetic, didRemove node: Node) {
        print("didRemove -> \(node)")
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
    }
}

//extension TypeViewController:GenreDelegate{
//    func recieveGenre(id: String?) {
//        <#code#>
//    }
//}
