//
//  DataFetch.swift
//  MovieCheckList
//
//  Created by Steven Lin on 2020/9/2.
//  Copyright © 2020 Steven Lin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//https://image.tmdb.org/t/p/w1280//ugZW8ocsrfgI95pnQ7wrmKDxIe.jpg
//https://api.themoviedb.org/3/discover/movie?api_key=3c896c42261d1a3460856bea4edb9dea&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&primary_release_year=2020.json

enum AddrType {
    case movieList
    case searchList
    case castList
}

class DataFetch {
    static let shared = DataFetch()
    
    var nowAddr: String?
    var nowYearNum = Calendar.current.component(.year, from: Date())
    var searchYearNum:Int{
        get{
            return nowYearNum
        }
    }
    var pageNum = 1
    
    func listAddr(genre: String?, page:String?, year: String) -> String{
        var pagePart:String{
            guard let page = page else { return "" }
            return "&page=\(page)"
        }
        
        var genrePart: String{
            guard let genre = genre else {return ""}
            return "&with_genres=\(genre)"
        }
        
        let addr = Addr.movieListAddr +
            AddrPara.discover +
            AddrPara.movie +
            AddrPara.apiKey +
            AddrPara.dicParameters["sort"]! +
            AddrPara.dicParameters["language"]! +
            AddrPara.dicParameters["adult"]! +
            AddrPara.dicParameters["video"]! +
            "&year=\(year)" +
            pagePart +
            genrePart
        
        nowAddr = addr
        return addr
    }
    
    func searchMovieAddr(title: String) -> String{
        let addr = Addr.movieListAddr +
            AddrPara.search +
            AddrPara.movie +
            AddrPara.apiKey +
            AddrPara.dicParameters["language"]! +
            AddrPara.dicParameters["adult"]! +
            "&query=\(title)"
        
        nowAddr = addr
        return addr
    }
    
    func searchPersonAddr(query: String) -> String{
        let titleStr  = query.replacingOccurrences(of: " ", with: "%20")
        let addr = Addr.movieListAddr +
            AddrPara.search +
            AddrPara.person +
            AddrPara.apiKey +
            AddrPara.dicParameters["language"]! +
            AddrPara.dicParameters["adult"]! +
            "&query=\(titleStr)"
        
        nowAddr = addr
        return addr
    }
    
    func creditAddr(id: String) -> String{
        let addr = Addr.movieListAddr +
            AddrPara.movie +
            "/\(id)" +
            AddrPara.apiKey +
            AddrPara.dicParameters["credit"]!
        
        nowAddr = addr
        return addr
    }
    
    func actorAddr(nameID: String, page: String) -> String{
        let addr = Addr.movieListAddr +
        AddrPara.discover +
        AddrPara.movie +
        AddrPara.apiKey +
        AddrPara.dicParameters["sort"]! +
        "&with_cast=\(nameID)" +
        "&page=\(page)"
        
        nowAddr = addr
        return addr
    }
    
    func similarAddr(id: String, page: String) -> String{
        let addr = Addr.movieListAddr +
            AddrPara.movie + "/\(id)" +
            AddrPara.similar +
            AddrPara.apiKey +
            AddrPara.dicParameters["language"]!
        
        nowAddr = addr
        return addr
    }
    
    func genreAddr() -> String{
        let addr = Addr.movieListAddr +
            AddrPara.genre +
            AddrPara.movie +
            AddrPara.list +
            AddrPara.apiKey +
            AddrPara.dicParameters["language"]!
        
        nowAddr = addr
        return addr
    }
    
    func videoAddr(title: String) -> String{
        let titleStr  = title.replacingOccurrences(of: " ", with: "+")
        return "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(titleStr)+official+trailer&key=AIzaSyDh7nmt2rBehMamOoqS9OIhM1bh2JnKpOU&type=video&maxResults=1"
    }
    
    func fetchMovieListData(addr: String, completion: @escaping(Result<FetchResult?, Error>) -> Void){
        
        fetchAPIData(addr: addr, completion: completion)
    }
    
    func fetchCastData(addr: String, completion: @escaping(Result<MovieDetailInfo?, Error>) -> Void){
        fetchAPIData(addr: addr, completion: completion)
    }
    
    func searchVideoData(title: String, completion: @escaping(Result<TrailerData?, Error>) -> Void){
        let addr = videoAddr(title: title)
        fetchAPIData(addr: addr, completion: completion)
    }
    
    func fetchActorID(addr: String, completion: @escaping(Result<Int64?, Error> ) -> Void){
        AF.request(addr).responseJSON { (res) in
            switch res.result{
            case .success(let data):
                let json = JSON(data)
                completion(.success(json["results"].array?[0]["id"].int64))
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func fetchActorMovieData(page: Int, nameID: Int, completion: @escaping(Result<FetchResult?, Error>) -> Void){
        let addr = actorAddr(nameID: String(nameID), page: String(page))
        fetchAPIData(addr: addr, completion: completion)
    }
    
    func fetchSimilarMovieData(page: Int, id: Int, completion: @escaping(Result<FetchResult?, Error>) -> Void){
        let addr = similarAddr(id: String(id), page: String(page))
        fetchAPIData(addr: addr, completion: completion)
    }
    
    func fetchGenreData(completion: @escaping(Result<GnereDatas?, Error>) -> Void){
        let addr = genreAddr()
        fetchAPIData(addr: addr, completion: completion)
    }
    
    fileprivate func fetchAPIData<T: Decodable>(addr: String, completion: @escaping (Result<T?, Error>) -> ()){
        AF.request(addr).responseData { (response) in
            switch response.result{
            case let .success(val):
                do {
                    let objects = try JSONDecoder().decode(T.self, from: val)
                    completion(.success(objects))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

