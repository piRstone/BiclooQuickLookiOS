//
//  StationList.swift
//  BiclooQuickLookiOS
//
//  Created by Pierre Lavalley on 24/07/2020.
//  Copyright © 2020 Pierre Lavalley. All rights reserved.
//

import SwiftUI

struct StationList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Binding var showStationList: Bool
    @State private var searchText: String = ""
    
    private func saveStation(_ station: Station) {
        print("Save station \(station.name)")
        let storedStation = StoredStation(context: AppDelegate.viewContext)
        storedStation.name = station.name
        storedStation.number = Int16(station.number)
        
        // Save station
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Error while saving station: \(error)")
        }
        
        // Close modal
        self.showStationList = false
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, placeholder: "Rechercher")
                List {
                    ForEach(stationData.filter {
                        self.searchText.isEmpty || $0.name.lowercased().contains(self.searchText.lowercased())
                    }) { station in
                        Text(station.name)
                            .onTapGesture {
                                self.saveStation(station)
                        }
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
        StationList(showStationList: .constant(true)).environment(\.managedObjectContext, AppDelegate.viewContext)
    }
}
