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
    func WikipediaRequestCompleted(result: WikipediaResult)
    func WikipediaRequestFailed(error: WikipediaAPIManager.FailureReason)
}
class WikipediaAPIManager {
    
    enum FailureReason: String {
        case networkRequestFailed = "Your request failed, please try again."
        case noData = "No Wiki data received"
        case badJSONResponse = "Bad JSON response"
    }
    
    var delegate : WikipediaDelegate?
    
    func getWikiURLForString(searchString: String) {
        let urlComponents = URLComponents(string: "\(WIKI_API)\(searchString)")!
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                self.delegate?.WikipediaRequestFailed(error: .networkRequestFailed)
                return
            }
            //ensure data is non-nil
            guard let data = data else {
                self.delegate?.WikipediaRequestFailed(error: .noData)
                return
            }
            let decoder = JSONDecoder()
            let decodedWikipediaResult = try? decoder.decode(WikipediaResult.self, from: data)
            
            guard let wikipediaResult = decodedWikipediaResult else {
                self.delegate?.WikipediaRequestFailed(error: .badJSONResponse)
                return
            }
            
            self.delegate?.WikipediaRequestCompleted(result: wikipediaResult)
        }
        
        task.resume()
    }
}
