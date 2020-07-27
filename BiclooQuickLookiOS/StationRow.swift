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
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    Text(station.name)
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("- \(station.number)")
                        .foregroundColor(.gray)
                }
                VStack(alignment: .leading) {
                    HStack {
                        if station.available_bikes > 0 {
                            Text("🚲")
                                .padding(.horizontal, 2)
                            Text("\(station.available_bikes) vélos disponibles")
                        } else {
                            Text("🚲")
                                .padding(.horizontal, 2)
                            Text("Aucun vélo disponible")
                        }
                    }
                    HStack {
                        if station.available_bike_stands > 0 {
                            Text("📍")
                                .padding(.horizontal, 2)
                            Text("\(station.available_bike_stands) places disponibles")
                        } else {
                            Text("📍")
                                .padding(.horizontal, 2)
                            Text("Aucune place disponible")
                        }
                    }
                }
                .padding(.top, 10)
            }
            .padding()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .leading)
        .background(Color(red: 0.95, green: 0.95, blue: 0.95, opacity: 1.0))
        .cornerRadius(10)
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
