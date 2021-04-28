//
//  BriefInfoViewModel.swift
//  WantToWatchMovie
//
//  Created by Steven Lin on 2021/3/17.
//  Copyright © 2021 Steven Lin. All rights reserved.
//

import Foundation

protocol BriefInfoViewModelProtocol{
    var overviewContent: Dynamic<String> {get}
    var releaseDateContent: Dynamic<String> {get}
    var voteAverageContent: Dynamic<String> {get}
    
    var similarDatas: Dynamic<(id: Int, imgPath: String, title: String)> {get}
    
    func clearContent()
    func setContent()
}

class BriefInfoViewModel: BriefInfoViewModelProtocol{
    var content: (overview: String, release: String, avg: Double)
    
    var similarDatas: Dynamic<(id: Int, imgPath: String, title: String)>
    var voteAverageContent: Dynamic<String>
    var overviewContent: Dynamic<String>
    var releaseDateContent: Dynamic<String>
    
    init(data: (overview: String, release: String, avg: Double, id: Int, imgPath: String, title: String)){
        voteAverageContent = Dynamic("Score: \(BriefInfoViewModel.setStringIfNil(val: data.avg, str: ""))")
        releaseDateContent = Dynamic("Release: " + data.release)
        overviewContent = Dynamic("Overview:\n" + data.overview)
        
        similarDatas = Dynamic((id: data.id, imgPath: data.imgPath, title: data.title))
        
        content = (data.overview, data.release, data.avg)
    }
    
    func clearContent() {
        voteAverageContent.value = BriefInfoViewModel.setStringIfNil(val: nil, str: "")
        releaseDateContent.value = ""
        overviewContent.value = ""
    }
    
    func setContent(){
        voteAverageContent.value = "Score: \(BriefInfoViewModel.setStringIfNil(val: content.avg, str: ""))"
        releaseDateContent.value = "Release: " + content.release
        overviewContent.value = "Overview:\n" + content.overview
    }
    
    fileprivate static func setStringIfNil(val: Double?, str: String) -> String{
        guard let doubleVal = val else{
            return str
        }
        return String(doubleVal)
    }
}
