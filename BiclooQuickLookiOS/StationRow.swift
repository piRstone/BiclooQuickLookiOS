//
//  StationRow.swift
//  BiclooQuickLookiOS
//
//  Created by Pierre Lavalley on 24/07/2020.
//  Copyright © 2020 Pierre Lavalley. All rights reserved.
//

import SwiftUI

struct StationRow: View {
    let station: StoredStation
    
    var body: some View {
        Text(station.name!)
    }
}

//struct StationRow_Previews: PreviewProvider {
//    var station = StoredStation()
//    station.name = "Picasso"
//    station.number = 12
//
//    static var previews: some View {
//        StationRow()
//    }
//}
