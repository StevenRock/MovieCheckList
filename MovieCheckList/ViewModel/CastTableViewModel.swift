//
//  CastTableViewModel.swift
//  WantToWatchMovie
//
//  Created by Steven Lin on 2021/3/17.
//  Copyright © 2021 Steven Lin. All rights reserved.
//

import Foundation

protocol CastTableViewModelProtocol{
    func fetchCastData()
    var castInfos: Dynamic<[CastData]> {get}
}

class CastTableViewModel: CastTableViewModelProtocol{
    var castInfos: Dynamic<[CastData]>
    var castId: String?
    
    init(with id: Int) {
        castInfos = Dynamic([])
        castId = String(id)
    }
    
    func fetchCastData() {
        guard let id = castId else {return}
        let castAddr = DataFetch.shared.creditAddr(id: id)
        DataFetch.shared.fetchCastData(addr: castAddr) { (res) in
            switch res{
            case .success(let data):
                self.castInfos.value = data?.credits?.cast ?? []
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


