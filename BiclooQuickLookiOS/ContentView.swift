//
//  ContentView.swift
//  BiclooQuickLookiOS
//
//  Created by Pierre Lavalley on 24/07/2020.
//  Copyright © 2020 Pierre Lavalley. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @FetchRequest(
        entity: StoredStation.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \StoredStation.number, ascending: true)]
    ) var stations: FetchedResults<StoredStation>
    
    @State var showStationList = false
    
    var AddButton: some View {
        Button(action: { self.showStationList.toggle() }) {
            Image(systemName: "plus")
                .imageScale(.large)
                .accessibility(label: Text("Ajouter une station"))
                .padding()
        }
    }

    var body: some View {
        NavigationView {
//            Text("Ajoutez une station pour commencer")
//                .foregroundColor(.gray)
            VStack {
                if stations.count >= 0 {
                    List {
                        ForEach(stations, id: \.number) {
                            StationRow(station: $0)
                        }
                    }
                } else {
                    Text("Ajoutez une station pour commencer")
                        .foregroundColor(.gray)
                }
            }
            .navigationBarTitle(Text("Bicloo Quick Look"))
            .navigationBarItems(trailing: AddButton)
            .sheet(isPresented: $showStationList) {
                StationList(showStationList: self.$showStationList)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
