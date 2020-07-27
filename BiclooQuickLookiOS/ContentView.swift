//
//  ContentView.swift
//  BiclooQuickLookiOS
//
//  Created by Pierre Lavalley on 24/07/2020.
//  Copyright © 2020 Pierre Lavalley. All rights reserved.
//

import SwiftUI

struct Response: Codable {
    var results: [Station]
}

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: StoredStation.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \StoredStation.number, ascending: true)]
    ) var favoriteStations: FetchedResults<StoredStation>
    
    @State var showStationList = false
    @State private var stations = [Station]()
    
    func fetchStations() {
        guard let JCDECAUX_API_KEY = ProcessInfo.processInfo.environment["JCDECAUX_API_KEY"] else {
            fatalError("No JCDECAUX_API_KEY filled")
        }
        guard let url = URL(string: "https://api.jcdecaux.com/vls/v1/stations?contract=nantes&apiKey=\(JCDECAUX_API_KEY)") else {
            print("Invalid URL")
            return
        }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Station].self, from: data) {
                    DispatchQueue.main.async {
                        self.stations = decodedResponse
                    }
                    return
                }
            }
            
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    func deleteStation(at offsets: IndexSet) {
        offsets.forEach { index in
            let station = self.favoriteStations[index]
            
            self.managedObjectContext.delete(station)
            
            do {
                try self.managedObjectContext.save()
            } catch {
                print("Error while saving after delete \(error)")
            }
        }
    }
    
    var ReloadButton: some View {
        Button(action: { self.fetchStations() }) {
            Image(systemName: "gobackward")
            .imageScale(.large)
            .accessibility(label: Text("Rafraichir les stations"))
        }
    }
    
    var AddButton: some View {
        Button(action: { self.showStationList.toggle() }) {
            Image(systemName: "plus")
                .imageScale(.large)
                .accessibility(label: Text("Ajouter une station"))
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                if favoriteStations.count >= 0 {
                    List {
                        ForEach(self.stations) { station in
                            StationRow(station: station)
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
            .onAppear(perform: {
                // Request stations data
                self.fetchStations()
                
                // Remove List dividers
                UITableView.appearance().separatorStyle = .none
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, AppDelegate.viewContext)
    }
}
