//
//  GenreViewModel.swift
//  WantToWatchMovie
//
//  Created by Steven Lin on 2021/4/19.
//  Copyright © 2021 Steven Lin. All rights reserved.
//

import Foundation

protocol GenreViewModelProtocol  {
    func fetchGenreDatas()
    func addGenreID(genre: String)
    func reduceGenreID(genre: String)
    
    var genreDatas: Dynamic<[Genres]> {get}
    var chosedGenreDatas: Dynamic<[Genres]> {get}
}

class GenreViewModel: GenreViewModelProtocol{

    var genreDatas: Dynamic<[Genres]>
    var chosedGenreDatas: Dynamic<[Genres]>
    
    init() {
        chosedGenreDatas = Dynamic([])
        genreDatas = Dynamic([])
    }
    
    func fetchGenreDatas() {
        DataFetch.shared.fetchGenreData { (result) in
            switch result{
            case .success(let data):
                guard let genres = data?.genres else {return}
                
                self.genreDatas.value = genres
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func reduceGenreID(genre: String) {
        if let index = chosedGenreDatas.value.firstIndex(where: {$0.name == genre}){
            chosedGenreDatas.value.remove(at: index)
            print("chosed value: \(chosedGenreDatas.value)")
        }
    }
    
    func addGenreID(genre: String) {
        if let index = genreDatas.value.firstIndex(where: {$0.name == genre}){
            chosedGenreDatas.value.append(genreDatas.value[index])
            print("chosed value: \(chosedGenreDatas.value)")
        }
    }
}
