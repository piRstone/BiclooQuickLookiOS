//
//  StationRow.swift
//  BiclooQuickLookiOS
//
//  Created by Pierre Lavalley on 24/07/2020.
//  Copyright © 2020 Pierre Lavalley. All rights reserved.
//

import SwiftUI

struct StationRow: View {
    let station: Station
    
    var body: some View {
        VStack {
            HStack {
                Text(station.name)
                    .font(.headline)
                    .fontWeight(.bold)
                Text("- \(station.number)")
                    .foregroundColor(.gray)
            }
            VStack(alignment: .leading) {
                if station.available_bikes > 0 {
                    Text("\(station.available_bikes) vélos disponibles")
                        .foregroundColor(.green)
                } else {
                    Text("Aucun vélo disponible")
                        .foregroundColor(.red)
                }
                if station.available_bike_stands > 0 {
                    Text("\(station.available_bike_stands) places disponibles")
                        .foregroundColor(.green)
                } else {
                    Text("Aucune place disponible")
                        .foregroundColor(.red)
                }
            }
            .padding(.top, 10)
        }
    }
}

struct StationRow_Previews: PreviewProvider {
//    var station = StoredStation()
//    station.name = "Picasso"
//    station.number = 12

    static var previews: some View {
        StationRow(station: stationData[0])
            .previewLayout(.sizeThatFits)
    }
}
