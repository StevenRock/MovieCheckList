//
//  DetailDegmentViewModel.swift
//  WantToWatchMovie
//
//  Created by Steven Lin on 2021/3/17.
//  Copyright © 2021 Steven Lin. All rights reserved.
//

import Foundation

protocol DetailDegmentViewModelProtocol {
    var title: Dynamic<String> {get}
    var poster_path: Dynamic<String> {get}
    var id: Dynamic<Int> {get}
    
    var briefInfo: Dynamic<(overview: String, release: String, avg: Double,
                            id: Int, imgPath: String, title: String)> {get}
    
    func checkIfInfoIsSaved(title: String)->Bool
    func saveUserDefault(title: String, strImg: String, strRecommand: String, isWatched: Bool, date: String, review: String, movieID: Int64) -> Bool
}

class DetailDegmentViewModel: DetailDegmentViewModelProtocol{
    
    var briefInfo: Dynamic<(overview: String, release: String, avg: Double,
                            id: Int, imgPath: String, title: String)>
    var title: Dynamic<String>
    var poster_path: Dynamic<String>
    var id: Dynamic<Int>

    
    init(data: MovieData) {
        title = Dynamic(data.title ?? "Err")
        poster_path = Dynamic(data.poster_path ?? "Err")
        id = Dynamic(data.id)
        briefInfo = Dynamic((data.overview ?? "Err",
                             data.release_date ?? "Err",
                             data.vote_average ?? 0.0,
                             data.id,
                             data.poster_path ?? "Err",
                             data.title ?? "Err"))
        
    }
    
    func checkIfInfoIsSaved(title: String) -> Bool{
        return UserDefaultManager.shared.isSaved(val: title)
    }
    
    func saveUserDefault(title: String, strImg: String, strRecommand: String, isWatched: Bool, date: String, review: String, movieID: Int64) -> Bool {
        if !UserDefaultManager.shared.isSaved(val: title){
            UserMovieManager.shared.add(title: title, strImg: strImg, strRecommand: strRecommand, isWatched: isWatched, date: date, review: review, movieID: movieID)
            UserDefaultManager.shared.saveUserDefault(val: title)
            return true
        }else{
            return false
        }
    }
}
