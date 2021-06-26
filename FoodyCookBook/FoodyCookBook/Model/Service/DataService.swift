//
//  DataService.swift
//  FoodyCookBook
//
//  Created by Tim on 26/06/2021.
//

import Foundation
//
//struct DataService {
//    //MARK:- Singleton
//    static let shared = DataService()
//
//    //MARK:- Services
//    func requestPost(completion: @escaping ([Food?], Error?) -> ()) {
//        let url = URL(string: "www.themealdb.com/api/json/v1/1/random.php")!
//
//        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//            if let error = error {
//                print("Error with fetching films: \(error)")
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse,
//                  (200...299).contains(httpResponse.statusCode) else {
//                print("Error with the response, unexpected status code: \(response ?? URLResponse())")
//                return
//            }
//
//            if let data = data,
//               let postData = try? JSONDecoder().decode([Food].self, from: data) {
//                completion(postData, nil)
//            }
//        })
//        task.resume()
//    }
//}

class DataService  {
    
    var delegate : FoodProtocols?
    var searchDelegate: SearchFoodProtocols?
    
    func loadData() {
        let weatherUrl = "https://www.themealdb.com/api/json/v1/1/random.php"
        guard let url = URL(string: weatherUrl) else {return}
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do{
                    let jsonDecoder = JSONDecoder()
                    let dataFromJson =  try jsonDecoder.decode(Food.self, from: data)
                    self.delegate?.getFood(food: dataFromJson)
                }
                catch {
                    
                }
            }
        }.resume()
    }
    
    func loadSearchData(query: String) {
        let weatherUrl = "https://www.themealdb.com/api/json/v1/1/search.php?s=\(query)"
        guard let url = URL(string: weatherUrl) else {return}
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do{
                    let jsonDecoder = JSONDecoder()
                    let dataFromJson =  try jsonDecoder.decode(Food.self, from: data)
                    self.searchDelegate?.getFood(food: dataFromJson)
                }
                catch {
                    print("error", error)
                }
            }
        }.resume()
    }
    
}
