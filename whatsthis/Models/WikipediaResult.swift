//
//  WikipediaResult.swift
//  whatsthis
//
//  Created by Edwin Abraham on 12/4/17.
//  Copyright © 2017 Edwin Abraham. All rights reserved.
//

import Foundation

//generated using http://danieltmbr.github.io/JsonCodeGenerator/

struct WikipediaResult: Codable {
    
    let batchcomplete: String
    let query: Query
    
}

struct Query: Codable {
    
    let normalized: [Normalized]
    let pages: [String : Page]
    
}

struct Normalized: Codable {
    
    let from: String
    let to: String
    
}

struct Page: Codable {
    
    let pageid: Int
    let ns: Int
    let title: String
    let extract: String
    
}

