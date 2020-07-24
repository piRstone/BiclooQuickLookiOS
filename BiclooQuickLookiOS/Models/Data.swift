//
//  Data.swift
//  BiclooQuickLookiOS
//
//  Created by Pierre Lavalley on 24/07/2020.
//  Copyright © 2020 Pierre Lavalley. All rights reserved.
//

import CoreLocation
import SwiftUI

let stationData: [Station] = load()

func load<T: Decodable>() -> T {
    let data: Data
    let filename: String = "stations.json"
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}


// MARK: For later: real time data HTTP request
//func load() -> [Station] {
//    let API_KEY: String = "$(JCDECAUX_API_KEY)"
//
//    let url = URL(string: "https://api.jcdecaux.com/vls/v1/stations?contract=nantes&apiKey=\(API_KEY)")!
//    let stationsReq = URLSession.shared.dataTask(with: url) { data, response, error in
//        if let error = error {
//            print("An error occured while requiring stations. \(error)")
//            return
//        }
//
//        guard let httpResponse = response as? HTTPURLResponse,
//            (200...299).contains(httpResponse.statusCode) else {
//                print("Error: status")
//                return
//        }
//
//        if let data = data {
//            do {
//                let res = try JSONDecoder().decode([Station].self, from: data)
//                print(res)
//            } catch {
//                fatalError("Couldn't decode station: \(error)")
//            }
//        }
//    }
//    stationsReq.resume()
//}
