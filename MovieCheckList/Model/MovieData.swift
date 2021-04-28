//
//  MovieData.swift
//  MovieCheckList
//
//  Created by Steven Lin on 2020/9/1.
//  Copyright © 2020 Steven Lin. All rights reserved.
//

import Foundation

var GlobalGenreStr: String?
//MARK: - MOVIE
struct FetchResult: Decodable{
    var page: Int64
    var total_pages: Int64
    var results: [MovieData]
    var total_results: Int64
}

struct MovieData: Decodable{
    var title: String?
    var vote_average: Double?
    var release_date: String?
    var poster_path: String?
    var id: Int
    var overview: String?
    var backdrop_path: String?
//    var homePage: String
//    var adult: Bool
}

struct MovieDetailInfo: Decodable{
//    var original_language: String?
//    var original_title: String?
    var credits: Credits?
}
//MARK: - CAST AND CREW
struct Credits: Decodable{
    var cast: [CastData]?
    var crew: [CrewsData]?
}

struct CrewsData: Decodable{
    var adult: Bool?
    var gender: Int?
    var id: Int?
    var known_for_department: String?
    var name: String?
    var original_name: String?
    var popularity: Double?
    var profile_path: String?
    var credit_id: String?
    var department: String?
    var job: String?
}

struct CastData: Decodable{
    var name: String?
    var character: String?
    var profile_path: String?
    var id: Int?
}
// MARK: TRAILER
struct TrailerData: Decodable{
    var etag : String?
    var items : [Item]?
    var kind : String?
    var nextPageToken : String?
    var regionCode : String?
}

struct Item: Decodable{
    var etag : String?
    var id : Id?
    var kind : String?
}

struct Id: Decodable{
    var kind : String?
    var videoId : String?
}

struct GnereDatas: Decodable{
    var genres: [Genres]?
}

struct Genres: Decodable{
    var id: Int64?
    var name: String?
}

// MARK: - CORE DATA
struct SavedMovieData: Codable{
    var title: String?
    var poster_path: String?
    var recommand: String?
    var isWatched: Bool?
}
//MARK: - ADDR
enum AddrPara {
    static let discover = "/discover"
    static let search = "/search"
    static let movie = "/movie"
    static let person = "/person"
    static let similar = "/similar"
    static let genre = "/genre"
    static let list = "/list"
    static let apiKey = "?api_key=3c896c42261d1a3460856bea4edb9dea"
    static let dicParameters: [String: String] = ["sort":"&sort_by=popularity.desc",
                                                  "language":"&\(Locale.current.identifier)",
                                               "adult":"&include_adult=false",
                                               "video":"&include_video=false",
                                               "credit":"&append_to_response=credits"]
}

enum Addr{
    static let movieListAddr = "https://api.themoviedb.org/3"
//    static let movieListAddr = "https://api.themoviedb.org/3/discover/movie?api_key=3c896c42261d1a3460856bea4edb9dea&sort_by=popularity.desc&language=zh-TW&include_adult=false&include_video=false"
       //https://api.themoviedb.org/3/discover/movie?api_key=3c896c42261d1a3460856bea4edb9dea&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&year=2019
    
    static let picAddr = "https://image.tmdb.org/t/p/w500"
}
//MARK: - TYPE
enum SearchType:String, CaseIterable {
    case popularity = "Popularity"
    case actor = "Actor / Actress"
    case movieTitle = "Movie Title"
}
