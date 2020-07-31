//
//  FavoriteJourneyRow.swift
//  BiclooQuickLookiOS
//
//  Created by Pierre Lavalley on 31/07/2020.
//  Copyright © 2020 Pierre Lavalley. All rights reserved.
//

import SwiftUI

struct FavoriteJourneyRow: View {
    let favBegStation: Station
    let favEndStation: Station
    
    func getBackgroundColor() -> LinearGradient {
        if favBegStation.available_bikes == 0 || favEndStation.available_bike_stands == 0 {
            // Journey not possible
            return LinearGradient(gradient: Gradient(colors: [Color(red: 0.9, green: 0.2, blue: 0.3), Color(red: 0.9, green: 0.4, blue: 0.3)]), startPoint: .leading, endPoint: .trailing)
        } else if (favBegStation.available_bikes > 0 && favBegStation.available_bikes <= 2) || (favEndStation.available_bike_stands > 0 && favEndStation.available_bike_stands <= 2) {
            // Journey may not be possible
            return LinearGradient(gradient: Gradient(colors: [Color(red: 1.0, green: 0.6, blue: 0.1), Color(red: 1.0, green: 0.8, blue: 0.0)]), startPoint: .leading, endPoint: .trailing)
        } else {
            // Journey possible
            return LinearGradient(gradient: Gradient(colors: [Color(red: 0.3, green: 0.7, blue: 0.2), Color(red: 0.7, green: 0.9, blue: 0.4)]), startPoint: .leading, endPoint: .trailing)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text(favBegStation.name)
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    Text("🚲 \(String(favBegStation.available_bikes))")
                        .fontWeight(.bold)
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: 150)
                Spacer()
                Text("➡️")
                Spacer()
                VStack {
                    Text(favEndStation.name)
                        .font(.caption)
                        .padding(.bottom, 5)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                    Text("📍 \(String(favEndStation.available_bike_stands))")
                        .fontWeight(.bold)
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: 150)
            }
            .padding()
        }
        .background(getBackgroundColor())
        .cornerRadius(10)
    }
}

struct FavoriteJourneyRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FavoriteJourneyRow(favBegStation: stationData[0], favEndStation: stationData[6])
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Journey possible")
            FavoriteJourneyRow(favBegStation: stationData[67], favEndStation: stationData[36])
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Journey may not be possible")
            FavoriteJourneyRow(favBegStation: stationData[20], favEndStation: stationData[87])
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Journey not possible")
        }
    }
}
