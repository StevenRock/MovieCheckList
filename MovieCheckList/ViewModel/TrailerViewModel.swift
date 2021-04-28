//
//  TrailerViewModel.swift
//  WantToWatchMovie
//
//  Created by Steven Lin on 2021/3/29.
//  Copyright © 2021 Steven Lin. All rights reserved.
//

import Foundation

protocol TrailerViewModelProtocol{
    func fetchVideoData(name: String)
    var videoID: Dynamic<String> {get}
    var embededStr: Dynamic<String> {get}
}

class TrailerViewModel: TrailerViewModelProtocol{
    var embededStr: Dynamic<String>
    var videoID: Dynamic<String>
    
    init() {
        videoID = Dynamic("")
        embededStr = Dynamic("")
    }
    
    func fetchVideoData(name: String) {
        DataFetch.shared.searchVideoData(title: name) { (result) in
            switch result{
            case .success(let data):
                guard let videoId = data?.items?.first?.id?.videoId else {return}
                self.videoID.value = videoId
                self.embededStr.value = "<iframe width='100%' height='100%' src='https://www.youtube.com/embed/\(videoId)' frameborder='0' allow='accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture' allowfullscreen></iframe>"
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
