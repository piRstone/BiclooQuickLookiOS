//
//  ContentView.swift
//  BiclooQuickLookiOS
//
//  Created by Pierre Lavalley on 24/07/2020.
//  Copyright © 2020 Pierre Lavalley. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
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
    
    func deleteStation(at offsets: IndexSet) {
        offsets.forEach { index in
            let station = self.stations[index]
            
            self.managedObjectContext.delete(station)
            
            do {
                try self.managedObjectContext.save()
            } catch {
                print("Error while saving after delete \(error)")
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                if stations.count >= 0 {
                    List {
                        ForEach(stations, id: \.self) { station in
                            Text(station.name ?? "")
                        }
                    .onDelete(perform: deleteStation)
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
                    .environment(\.managedObjectContext, self.managedObjectContext)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, AppDelegate.viewContext)
    }
}
