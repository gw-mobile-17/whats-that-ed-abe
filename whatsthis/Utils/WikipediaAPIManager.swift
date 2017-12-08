//
//  WikipediaAPIManager.swift
//  whatsthis
//
//  Created by Edwin Abraham on 12/4/17.
//  Copyright © 2017 Edwin Abraham. All rights reserved.
//

import Foundation

let WIKI_API : String = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro=&explaintext=&titles="
let WIKI_URL : String = "https://en.wikipedia.org/?curid="

protocol WikipediaDelegate {
    func WikipediaRequestCompleted(result: GoogleVisionResult)
    func WikipediaRequestFailed(error: Error?)
}
class WikipediaAPIManager {
    
    var delegate : WikipediaDelegate?
    
    func getWikiURLForString(searchString: String) {
        let urlComponents = URLComponents(string: "\(WIKI_API)\(searchString)")!
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                
                self.delegate?.WikipediaRequestFailed(error: error!)
                
                return
            }
            //ensure data is non-nil
            guard let data = data else {
                self.delegate?.WikipediaRequestFailed(error: nil)
                return
            }
            let decoder = JSONDecoder()
            let decodedWikipediaResult = try? decoder.decode(WikipediaResult.self, from: data)
            
            guard decodedWikipediaResult != nil else {
                self.delegate?.WikipediaRequestFailed(error: nil)
                return
            }
        }
        
        task.resume()
    }
}
