//
//  EditReviewView.swift
//  WantToWatchMovie
//
//  Created by Steven Lin on 2021/3/31.
//  Copyright © 2021 Steven Lin. All rights reserved.
//

import UIKit

protocol CloseReviewViewDelegate{
    func close()
}

class EditReviewView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var datePickerTextField: UITextField!
    @IBOutlet weak var moodImage: UIImageView!
    @IBOutlet weak var reviewTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    fileprivate weak var nibView: UIView!
    var blurEffectView = UIVisualEffectView()
    var delegate: CloseReviewViewDelegate?
    
    var datePicker: UIDatePicker?
    var viewModel: EditReviewViewModelProtocol?{
        didSet{
            binding()
        }
    }
    
    var modifyData: (core: UserMovie, recommand: String)?
    
    init(frame: CGRect, vc: ChecklistViewController, coreData: UserMovie, strRecommand: String?, isEdit: Bool) {
        super.init(frame: frame)
        
        viewModel = EditReviewViewModel()
        self.delegate = vc
        loadViewFromNib(frame: frame)
        
        guard let title = coreData.title,
              let img = coreData.strImg,
              let review = coreData.review,
              let date = coreData.date,
              let rmd = coreData.strRecommand else {return }
        
        if isEdit{
            reviewTextView.text = "How about \(title)?"
            reviewTextView.textColor = UIColor.lightGray
            reviewTextView.delegate = self
            
            datePickerTextField.isEnabled = true
            setDatePicker()
            
            saveButton.isHidden = false
            
            moodImage.image = UIImage(named: strRecommand!)
            modifyData = (coreData, strRecommand!)
        }else{
            reviewTextView.text = review
            reviewTextView.isEditable = false
            
            datePickerTextField.text = date
            datePickerTextField.isEnabled = false
            
            saveButton.isHidden = true
            
            moodImage.image = UIImage(named: rmd)
        }

        titleLabel.text = title
        
        let url = URL(string: "\(Addr.picAddr)\(img)")
        movieImage.kf.indicatorType = .activity
        let placeHolder_img = UIImage(named: img)
        movieImage.kf.setImage(with: url, placeholder: placeHolder_img)
        
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        
        saveButton.layer.cornerRadius = 8
        cancelButton.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setDatePicker(){
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 200))
        datePicker?.addTarget(self, action: #selector(setTextField), for: .allEvents)
        datePickerTextField.inputView = datePicker
        datePicker?.maximumDate = Date()
        datePicker?.setDate(Date(), animated: true)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(datePickerDone))
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        datePickerTextField.inputAccessoryView = toolBar
    }
    
    @objc func datePickerDone(){
        datePickerTextField.resignFirstResponder()
    }
    
    @objc func setTextField() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        datePickerTextField.text = dateFormatter.string(from: datePicker!.date)
    }

    private func loadViewFromNib(frame: CGRect){
        let addInfoView: UIView = UINib.loadEditReviewView(self)
        addInfoView.frame = frame
        self.addSubview(addInfoView)
//        self.nibView = addInfoView
   }
    
    private func binding(){
//        viewModel?.strTitle.bindAndFire{[unowned self] in
//            titleLabel.text = $0
//        }
//        
//        viewModel?.strMovieImg.bindAndFire{[unowned self] in
//            movieImage.image = UIImage(named: $0)
//        }
//        
//        viewModel?.strMoodImg.bindAndFire{[unowned self] in
//            moodImage.image = UIImage(named: $0)
//        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        guard let core = modifyData?.core,
              let title = modifyData?.core.title,
              let strImg = modifyData?.core.strImg,
              let strRecommand = modifyData?.recommand,
              let isWatched = modifyData?.core.isWatched,
              let movieID = modifyData?.core.movieID,
              let date = datePickerTextField.text,
              let review = reviewTextView.text else {return }
        
        viewModel?.editReviewInfo(userMovie: core, title: title, strImg: strImg, strRecommand: strRecommand, isWatched: isWatched, date: date, review: review, movieID: movieID)
        delegate?.close()
    }
    @IBAction func cancel(_ sender: UIButton) {
        delegate?.close()
    }
}

extension EditReviewView: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let title = modifyData?.core.title else {return }
        
        if textView.text.isEmpty {
            textView.text = "How about \(title)?"
            textView.textColor = UIColor.lightGray
        }
    }
}
