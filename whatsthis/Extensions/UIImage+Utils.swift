//
//  UIImage+Utils.swift
//  whatsthis
//
//  Created by Edwin Abraham on 12/4/17.
//  Copyright © 2017 Edwin Abraham. All rights reserved.
//

import UIKit
//Extension to UIImage to handle base64Image Conversions
extension UIImage {
    func base64String () -> String {
        let imageData : Data = UIImageJPEGRepresentation(self, 0.3)!
        let imageString : String = imageData.base64EncodedString(options: .lineLength64Characters)
        return imageString
    }
    func imageFromBase64String(base64String: String) -> UIImage {
        let imageData : Data = Data(base64Encoded: base64String , options: .ignoreUnknownCharacters)!
        let image : UIImage =  UIImage(data: imageData)!
        return image
    }
}
