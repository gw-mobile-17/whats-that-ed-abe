//
//  PhotoModel.swift
//  whatsthis
//
//  Created by Edwin Abraham on 12/8/17.
//  Copyright © 2017 Edwin Abraham. All rights reserved.
//

import Foundation

class PhotoModel: NSObject {
    
    let text: String
    let imageString: String
    let id: Double
    let lat: Double
    let lon: Double
    
    let textKey = "text"
    let imageStringKey = "imageString"
    let idKey = "id"
    let latKey = "lat"
    let lonKey = "lon"
    
    init(text: String, imageString: String, id: Double, lat: Double?, lon: Double?) {
        
        self.text = text
        self.imageString = imageString
        self.id = id
        self.lat = lat ?? 200
        self.lon = lon ?? 200
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: textKey) as! String
        imageString = aDecoder.decodeObject(forKey: imageStringKey) as! String
        id = aDecoder.decodeDouble(forKey: idKey)
        lat = aDecoder.decodeDouble(forKey: latKey)
        lon = aDecoder.decodeDouble(forKey: lonKey)
    }
}

extension PhotoModel: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: textKey)
        aCoder.encode(imageString, forKey: imageStringKey)
        aCoder.encode(id, forKey: idKey)
        aCoder.encode(lat, forKey: latKey)
        aCoder.encode(lon, forKey: lonKey)
    }
}
