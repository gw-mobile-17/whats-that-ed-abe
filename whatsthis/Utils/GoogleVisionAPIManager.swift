//
//  GoogleVisionAPIManager.swift
//  whatsthis
//
//  Created by Edwin Abraham on 12/4/17.
//  Copyright © 2017 Edwin Abraham. All rights reserved.
//

import Foundation
import UIKit

let GOOGLE_VISION_KEY =  "AIzaSyDW0GaXhiGot6n2ssbeEOCOuCqogsdMgbQ"

let GOOGLE_VISION_API = "https://vision.googleapis.com/v1/images:annotate?key=\(GOOGLE_VISION_KEY)"

protocol GoogleVisionDelegate {
    func GoogleVisionRequestCompleted(result: GoogleVisionResult)
    func GoogleVisionRequestFailed(error: Error?)
}
class GoogleVisionAPIManager {
    
    var delegate: GoogleVisionDelegate?
    
    func getLabelsForImage(image : UIImage) -> String {
        let string = image.base64String()
        getLabelsForImageString(imageString: string)
        return string
    }
    
    func getLabelsForImageString(imageString: String) {
        let urlComponents = URLComponents(string: GOOGLE_VISION_API)!
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let json = [
            "requests": [
                [
                    "image" : [
                        "content": imageString
                    ],
                    "features" : [
                        [
                            "type" : "LABEL_DETECTION"
                        ]
                    ]
                ]
            ]
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                self.delegate?.GoogleVisionRequestFailed(error: error!)
                return
            }
            
            //ensure data is non-nil
            guard let data = data else {
                self.delegate?.GoogleVisionRequestFailed(error: nil)
                return
            }
            
            let decoder = JSONDecoder()
            let decodedGoogleVisionResult = try? decoder.decode(GoogleVisionResult.self, from: data)
            
            guard let googleVisionResult = decodedGoogleVisionResult else {
                self.delegate?.GoogleVisionRequestFailed(error: nil)
                return
            }
            
            self.delegate?.GoogleVisionRequestCompleted(result: googleVisionResult)
        
        }
        
        task.resume()
    }
}
