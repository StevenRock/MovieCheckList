//
//  ChecklistViewModel.swift
//  WantToWatchMovie
//
//  Created by Steven Lin on 2021/3/23.
//  Copyright © 2021 Steven Lin. All rights reserved.
//

import Foundation

protocol ChecklistViewModelProtocol{
    var coreArr: Dynamic<[UserMovie]> {get}
    
    func fetch()
    func deleteCoreData(data: UserMovie)
    func editCoreData(userMovie: UserMovie, title: String, strImg: String, strRecommand: String, isWatched: Bool, date: String, review: String, movieID: Int64)
}

class ChecklistViewModel: ChecklistViewModelProtocol{
    var coreArr: Dynamic<[UserMovie]>
    
    init() {
        coreArr = Dynamic(ChecklistViewModel.fetchCoreData())
    }
    
    fileprivate static func fetchCoreData() -> [UserMovie]{
        guard let coreDataArr = UserMovieManager.shared.fetchAll() else { return [] }
        
        return coreDataArr
    }
    
    func fetch(){
        coreArr.value = ChecklistViewModel.fetchCoreData()
    }
    
    func deleteCoreData(data: UserMovie) {
        deleteUserDefault(val: data.title ?? "")
        UserMovieManager.shared.delete(userMovie: data)
        coreArr.value = ChecklistViewModel.fetchCoreData()
    }
    
    func editCoreData(userMovie: UserMovie, title: String, strImg: String, strRecommand: String, isWatched: Bool, date: String, review: String, movieID: Int64) {
        UserMovieManager.shared.edit(userMovie: userMovie, title: title, strImg: strImg, strRecommand: strRecommand, isWatched: true, date: date, review: review, movieID: movieID)
        
        coreArr.value = ChecklistViewModel.fetchCoreData()
    }
    
    fileprivate func deleteUserDefault(val: String) {
        UserDefaultManager.shared.deleteData(val: val)
    }
}
