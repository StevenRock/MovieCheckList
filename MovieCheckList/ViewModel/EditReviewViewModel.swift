//
//  EditReviewViewModel.swift
//  WantToWatchMovie
//
//  Created by Steven Lin on 2021/3/31.
//  Copyright © 2021 Steven Lin. All rights reserved.
//

import Foundation

protocol EditReviewViewModelProtocol{
    var strTitle: Dynamic<String> {get}
    var strMovieImg: Dynamic<String> {get}
    var strMoodImg: Dynamic<String> {get}
    
    func editReviewInfo(userMovie: UserMovie, title: String, strImg: String, strRecommand: String, isWatched: Bool, date: String, review: String, movieID: Int64)
}

class EditReviewViewModel: EditReviewViewModelProtocol{
    var strTitle: Dynamic<String>
    var strMovieImg: Dynamic<String>
    var strMoodImg: Dynamic<String>
    
    init() {
        strTitle = Dynamic("")
        strMovieImg = Dynamic("")
        strMoodImg = Dynamic("")
    }
    
    func editReviewInfo(userMovie: UserMovie, title: String, strImg: String, strRecommand: String, isWatched: Bool, date: String, review: String, movieID: Int64) {
        UserMovieManager.shared.edit(userMovie: userMovie, title: title, strImg: strImg, strRecommand: strRecommand, isWatched: true, date: date, review: review, movieID: movieID)
//        coreArr.value = ChecklistViewModel.fetchCoreData()
    }
}

//MARK: - 
extension EditReviewViewModel{
    
}
