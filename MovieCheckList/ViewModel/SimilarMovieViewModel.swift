//
//  SimilarMovieViewModel.swift
//  WantToWatchMovie
//
//  Created by Steven Lin on 2021/4/15.
//  Copyright © 2021 Steven Lin. All rights reserved.
//

import Foundation

protocol SimilarMovieViewModelProtocol{
    func fetchListData()
    func fetchNextPageData()
    
    var apiResults: Dynamic<[MovieData]> {get}
    var movieTitle: Dynamic<String> {get}
    var strImgPath: Dynamic<String> {get}
}

class SimilarMovieViewModel: SimilarMovieViewModelProtocol{
    
    var apiResults: Dynamic<[MovieData]>
    var movieTitle: Dynamic<String>
    var strImgPath: Dynamic<String>
    var nameID: Int
    var totalPage: Int64
    var currentPage: Int
    
    init(id: Int, name: String, imgPath: String) {
        apiResults = Dynamic([])
        nameID = id
        movieTitle = Dynamic("\(name)'s similar movies")
        strImgPath = Dynamic(imgPath)
        totalPage = 0
        currentPage = 1
    }
    
    func fetchListData(){
        DataFetch.shared.fetchSimilarMovieData(page: currentPage, id: nameID) { (result) in
            switch result{
            case .success(let data):
                guard let result = data?.results, let total_pages = data?.total_pages else {return}
                self.apiResults.value = result
                self.totalPage = total_pages
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchNextPageData(){
        if currentPage != totalPage{
            currentPage += 1
            
            DataFetch.shared.fetchSimilarMovieData(page: currentPage, id: nameID) { (result) in
                switch result{
                case .success(let data):
                    guard let result = data?.results else {return}
                    self.apiResults.value += result
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
