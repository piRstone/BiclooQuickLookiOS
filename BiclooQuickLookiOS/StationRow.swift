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
//                    Spacer()
//                    Image(systemName: "star.fill")
//                        .foregroundColor(.yellow)
                }
                VStack(alignment: .leading) {
                    HStack {
                        if station.available_bikes > 0 {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.green)
                                .padding(.horizontal, 2)
                            Text("\(station.available_bikes) vélo\(station.available_bikes > 1 ? "s" : "") disponible\(station.available_bikes > 1 ? "s" : "")")
                        } else {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.red)
                                .padding(.horizontal, 2)
                            Text("Aucun vélo disponible")
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.bottom, -5)
                    HStack {
                        if station.available_bike_stands > 0 {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.green)
                                .padding(.horizontal, 2)
                            Text("\(station.available_bike_stands) place\(station.available_bike_stands > 1 ? "s" : "") disponible\(station.available_bike_stands > 1 ? "s" : "")")
                        } else {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.red)
                                .padding(.horizontal, 2)
                            Text("Aucune place disponible")
                                .foregroundColor(.red)
                        }
                    }
                }
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
