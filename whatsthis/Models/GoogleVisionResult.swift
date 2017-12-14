//
//  GoogleVisionResult.swift
//  whatsthis
//
//  Created by Edwin Abraham on 12/4/17.
//  Copyright © 2017 Edwin Abraham. All rights reserved.
//

import Foundation

//generated using http://danieltmbr.github.io/JsonCodeGenerator/

struct GoogleVisionResult: Codable {
    
    let responses: [Response]
    
}
struct Response: Codable {
    
    let labelAnnotations: [LabelAnnotations]
    
}

struct LabelAnnotations: Codable {
    
    let mid: String
    let description: String
    let score: Double
    
}
