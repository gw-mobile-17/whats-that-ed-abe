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
    
    // fetches PhotoModel Objects from favorites persisted
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
    
    // Saves PhotoModel Object to favorites and persisted
    func savePhoto(_ photo: PhotoModel) {
        let userDefaults = UserDefaults.standard
        
        var photos = fetchPhotos()
        photos.append(photo)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: photos)
        
        userDefaults.set(data, forKey: favoriteImagesKey)
    }
    
    // Removes PhotoModel Object from favorites persisted
    func removePhoto(_ photo: PhotoModel) {
        let userDefaults = UserDefaults.standard
        
        var photos = fetchPhotos()
        
        // filters out photo object using id of photo
        photos = photos.filter{ $0.id != photo.id}
        
        let data = NSKeyedArchiver.archivedData(withRootObject: photos)
        
        userDefaults.set(data, forKey: favoriteImagesKey)
    }
}
