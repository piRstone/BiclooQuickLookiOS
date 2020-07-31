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
    
    func getBackgroundColor() -> Color {
        if favBegStation.available_bikes == 0 || favEndStation.available_bike_stands == 0 {
            return Color.red
        } else if (favBegStation.available_bikes > 0 && favBegStation.available_bikes <= 2) || (favEndStation.available_bike_stands > 0 && favEndStation.available_bike_stands <= 2) {
            return Color.orange
        } else {
            return Color.green
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
                    Text("📍 \(String(favEndStation.available_bikes))")
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
                .previewDisplayName("Journey maybe not possible")
            FavoriteJourneyRow(favBegStation: stationData[20], favEndStation: stationData[87])
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Journey not possible")
        }
    }
}
