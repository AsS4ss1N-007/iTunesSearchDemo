//
//  APIService.swift
//  iTunesSearchDemo
//
//  Created by Sachin's Macbook Pro on 06/04/21.
//

import UIKit
import Combine
class APIServices: NSObject {
    static let shared = APIServices()
    private let baseURL = "https://itunes.apple.com/search?term="
    var songInfo: SongInfo?
    func fetchSongs(term: String, completionHandler: @escaping (SongInfo) -> Void){
        guard let safeURL = URL(string: "\(baseURL)\(term)") else {return}
        URLSession.shared.dataTask(with: safeURL) { (data, res, err) in
            if let error = err{
                print(error.localizedDescription)
                return
            }else{
                guard let safeData = data else {return}
                do{
                    let jsonData = try JSONDecoder().decode(SongInfo.self, from: safeData)
                    DispatchQueue.main.async {
                        completionHandler(jsonData)
                    }
                }catch let jsonErr{
                    print(jsonErr.localizedDescription)
                    return
                }
            }
        }.resume()
        
    }
}
