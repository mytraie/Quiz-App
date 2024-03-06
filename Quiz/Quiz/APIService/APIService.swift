//
//  APIService.swift
//  Quiz
//
//  Created by Mytraie Chinthapatla on 29/2/24.
//

import Foundation

class APIService :  NSObject {
    
    private let sourcesURL = URL(string: "https://opentdb.com/api.php?amount=20&category=9&difficulty=hard&type=multiple")!
    
    func apiToGetQuizData(completion : @escaping (QuizApp) -> ()){
        // Create a URLSessionDataTask to fetch data
        URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
            if let data = data {
                // Decode the JSON data into the QuizApp model
                let jsonDecoder = JSONDecoder()
                let empData = try! jsonDecoder.decode(QuizApp.self, from: data)
                completion(empData)
            }
        }.resume()
    }
}
