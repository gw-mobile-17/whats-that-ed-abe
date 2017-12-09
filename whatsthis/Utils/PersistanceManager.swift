//
//  PersistanceManager.swift
//  whatsthis
//
//  Created by Edwin Abraham on 12/4/17.
//  Copyright © 2017 Edwin Abraham. All rights reserved.
//

import Foundation
class PersistanceManager {
    static let sharedInstance = PersistanceManager()
    
    let favoriteImagesKey = "photos"
    
    func fetchPhotos() -> [PhotoModel] {
        let userDefaults = UserDefaults.standard
        
        let data = userDefaults.object(forKey: favoriteImagesKey) as? Data
        
        if let data = data {
            //data is not nil, so use it
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? [PhotoModel] ?? [PhotoModel]()
        }
        else {
            //data is nil
            return [PhotoModel]()
        }
    }
    
    func savePhoto(_ photo: PhotoModel) {
        let userDefaults = UserDefaults.standard
        
        var photos = fetchPhotos()
        photos.append(photo)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: photos)
        
        userDefaults.set(data, forKey: favoriteImagesKey)
    }
    func removePhoto(_ photo: PhotoModel) {
        let userDefaults = UserDefaults.standard
        
        var photos = fetchPhotos()
        photos = photos.filter{ $0.id != photo.id}
        
        let data = NSKeyedArchiver.archivedData(withRootObject: photos)
        
        userDefaults.set(data, forKey: favoriteImagesKey)
    }
}
