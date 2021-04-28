//
//  UserDefault.swift
//  MovieCheckList
//
//  Created by Steven Lin on 2021/3/10.
//  Copyright © 2021 Steven Lin. All rights reserved.
//

import Foundation

class UserDefaultManager{
    static let shared = UserDefaultManager()
    
    let userDefault = UserDefaults.standard
    
    func saveUserDefault(val: String){
        userDefault.setValue(val, forKey: val)
    }
    
    func readUserDefault(val: String){
        userDefault.value(forKey: val)
    }
    
    func deleteData(val: String){
        userDefault.removeObject(forKey: val)
    }
    
    func isSaved(val: String?) -> Bool{
        return userDefault.object(forKey: val ?? "") != nil
    }
}
