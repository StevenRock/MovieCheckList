//
//  DataFetchViewModel.swift
//  WantToWatchMovie
//
//  Created by Steven Lin on 2021/3/12.
//  Copyright © 2021 Steven Lin. All rights reserved.
//

import Foundation

protocol DataFetchViewModelProtocol{
    func fetchListData(genre: String?, page: String, year: String)
    func fetchSearchResultdata(page: Int?, name: String)
    func fetchSearchPersonResultData(page: Int?, name: String)
    func switchSearchType(type: SearchType)
    
    var apiResults: Dynamic<[MovieData]> {get}
    var pageVal: Dynamic<(page: Int64, totalPage: Int64)> {get}
    var searchYearNum: Dynamic<Int> {get}
    var currentYear: Dynamic<Int> {get}
    var strSearchType: Dynamic<String> {get}
}

class DataFetchViewModel: DataFetchViewModelProtocol{
    
    var apiResults: Dynamic<[MovieData]>
    var pageVal: Dynamic<(page: Int64, totalPage: Int64)>
    var searchYearNum: Dynamic<Int>
    var currentYear: Dynamic<Int>
    var strSearchType: Dynamic<String>
    
    init() {
        apiResults = Dynamic([])
        pageVal = Dynamic((0,0))
        searchYearNum = Dynamic(DataFetch.shared.searchYearNum)
        currentYear = Dynamic(DataFetch.shared.nowYearNum)
        strSearchType = Dynamic(SearchType.popularity.rawValue)
    }
    
    func switchSearchType(type: SearchType) {
        switch type {
        case .popularity:
            strSearchType.value = SearchType.popularity.rawValue
            fetchListData(genre: nil, page: "1", year: "2021")
        case .actor:
            strSearchType.value = SearchType.actor.rawValue
            apiResults.value.removeAll()
            pageVal.value = (page: 0, totalPage: 0)
        case .movieTitle:
            strSearchType.value = SearchType.movieTitle.rawValue
        }
    }


    func fetchListData(genre: String?, page: String, year: String) {
        print(searchYearNum.value)
        let sendAPIAddr = DataFetch.shared.listAddr(genre: genre, page: page, year: year)
        
        DataFetch.shared.fetchMovieListData(addr: sendAPIAddr) { (data) in
            switch data{
            case .success(let data):
                guard let result = data?.results, let page = data?.page, let totalPage = data?.total_pages else {return}
                self.apiResults.value = result
                self.pageVal.value = (page, totalPage)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchSearchResultdata(page: Int?, name: String) {
        var apiAddr = DataFetch.shared.searchMovieAddr(title: name)
        
        if let page = page {
            apiAddr += "&page=\(page)"
        }
        DataFetch.shared.fetchMovieListData(addr: apiAddr) { (result) in
            switch result{
            case .success(let data):
                guard let result = data?.results, let page = data?.page, let totalPage = data?.total_pages else {return}
                self.apiResults.value = result
                self.pageVal.value = (page, totalPage)
                self.strSearchType.value = SearchType.movieTitle.rawValue
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchSearchPersonResultData(page: Int?, name: String){
        let apiAddr = DataFetch.shared.searchPersonAddr(query: name)
        
        DataFetch.shared.fetchActorID(addr: apiAddr) { (res) in
            switch res{
            case .success(let data):
                guard let data = data else {return}
                DataFetch.shared.fetchActorMovieData(page: page ?? 1, nameID: Int(data)) { (result) in
                    switch result{
                    case .success(let data):
                        guard let result = data?.results, let total_pages = data?.total_pages, let page = data?.page else {return}
                        self.apiResults.value = result
                        self.pageVal.value = (page, total_pages)
                        self.strSearchType.value = SearchType.actor.rawValue

                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        
//        DataFetch.shared.fetchMovieListData(addr: apiAddr) { (result) in
//            switch result{
//            case .success(let data):
//                guard let result = data?.results, let page = data?.page, let totalPage = data?.total_pages else {return}
//                self.apiResults.value = result
//                self.pageVal.value = (page, totalPage)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
}
