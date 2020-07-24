//
//  StationList.swift
//  BiclooQuickLookiOS
//
//  Created by Pierre Lavalley on 24/07/2020.
//  Copyright © 2020 Pierre Lavalley. All rights reserved.
//

import SwiftUI

struct StationList: View {
    @Binding var showStationList: Bool
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, placeholder: "Rechercher")
                List {
                    ForEach(stationData.filter {
                        self.searchText.isEmpty ? true : $0.name.lowercased().contains(self.searchText.lowercased())
                    }) { station in
                        Text(station.name)
                    }
                }
                .navigationBarTitle(Text("Ajouter une station"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: { self.showStationList = false }) {
                    Text("Annuler")
            })
            }
        }
    }
}

struct StationList_Previews: PreviewProvider {
    static var previews: some View {
        StationList(showStationList: .constant(true))
    }
}
