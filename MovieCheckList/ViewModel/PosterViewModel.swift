//
//  PosterViewModel.swift
//  WantToWatchMovie
//
//  Created by Steven Lin on 2021/3/17.
//  Copyright © 2021 Steven Lin. All rights reserved.
//

import Foundation

protocol PosterViewModelProtocol{
    var strImgName: Dynamic<String> {get}
}

class PosterViewModel: PosterViewModelProtocol{
    var strImgName: Dynamic<String>
        
    init(str: String) {
        strImgName = Dynamic(str)
    }
}
