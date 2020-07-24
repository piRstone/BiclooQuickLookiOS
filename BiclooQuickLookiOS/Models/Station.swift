//
//  Station.swift
//  BiclooQuickLookiOS
//
//  Created by Pierre Lavalley on 24/07/2020.
//  Copyright © 2020 Pierre Lavalley. All rights reserved.
//

import SwiftUI

struct Position: Codable {
    var lat: Double
    var lng: Double
}

struct Station: Codable, Identifiable {
    var address: String
    var available_bike_stands: Int
    var available_bikes: Int
    var banking: Bool
    var bike_stands: Int
    var bonus: Bool
    var contract_name: String
    var last_update: Double
    var name: String
    var number: Int
    var position: Position
    var status: Status
    
    var id: Int {
        number
    }
    
    enum Status: String, Codable {
        case open = "OPEN"
        case closed = "CLOSED"
    }
}
