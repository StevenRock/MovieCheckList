//
//  UserMovieManager.swift
//  MovieCheckList
//
//  Created by Steven Lin on 2020/9/10.
//  Copyright © 2020 Steven Lin. All rights reserved.
//

import Foundation
import CoreData

class UserMovieManager{
    static let shared = UserMovieManager()
    
    func add (title: String, strImg: String, strRecommand: String, isWatched: Bool, date: String, review: String, movieID: Int64){
        if let entity = NSEntityDescription.entity(forEntityName: "UserMovie", in: CoreDataManager.shared.persistentContainer.viewContext){
            let movie = UserMovie(entity: entity, insertInto: CoreDataManager.shared.persistentContainer.viewContext)
            movie.title = title
            movie.isWatched = isWatched
            movie.strImg = strImg
            movie.strRecommand = strRecommand
            movie.date = date
            movie.review = review
            movie.movieID = movieID
            
            CoreDataManager.shared.saveContext()
        }
    }
    
    func fetchAll() -> [UserMovie]?{
        let request: NSFetchRequest<UserMovie> = UserMovie.fetchRequest()
        do{
            let userMovie = try CoreDataManager.shared.persistentContainer.viewContext.fetch(request)
            return userMovie
        }catch{
            print(error.localizedDescription)
            return nil
        }
    }
    
    func delete(userMovie: UserMovie) {
        CoreDataManager.shared.persistentContainer.viewContext.delete(userMovie)
        CoreDataManager.shared.saveContext()
    }
    
    func edit(userMovie: UserMovie, title: String, strImg: String, strRecommand: String, isWatched: Bool, date: String, review: String, movieID: Int64) {
        userMovie.title = title
        userMovie.strImg = strImg
        userMovie.strRecommand = strRecommand
        userMovie.isWatched = isWatched
        userMovie.date = date
        userMovie.review = review
        userMovie.movieID = movieID
        
        CoreDataManager.shared.saveContext()
    }
}
