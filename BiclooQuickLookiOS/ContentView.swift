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
    @FetchRequest(
        entity: Settings.entity(),
        sortDescriptors: []
    ) var settings: FetchedResults<Settings>
    
    @State var showStationList = false
    @State var showSettings = false
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
            let station = self.stations[index]
            
            var favStationIndex: Int {
                self.favoriteStations.firstIndex(where: { $0.number == station.number })!
            }
            
            let favStation = self.favoriteStations[favStationIndex]

            self.managedObjectContext.delete(favStation)

            do {
                try self.managedObjectContext.save()
            } catch {
                print("Error while saving after delete \(error)")
            }
        }
    }
    
    func buildFavoriteJourney() -> some View {
        let favBegId = settings[0].favBegStation
        let favEndId = settings[0].favEndStation
        let begIndex = self.stations.firstIndex(where: { $0.number == favBegId })
        let endIndex = self.stations.firstIndex(where: { $0.number == favEndId })
        
        return VStack {
            if  begIndex == nil || endIndex == nil {
                FavoriteJourneyPlaceholder
            } else {
                VStack(alignment: .leading) {
                    Text("Trajet préféré".uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .padding(.leading)
                    FavoriteJourneyRow(favBegStation: self.stations[begIndex ?? 0], favEndStation: self.stations[endIndex ?? 0])
                        .padding(.horizontal)
                }
            }
        }
    }
    
    var FavoriteJourneyPlaceholder: some View {
        VStack {
            Text("Définissez vos stations favorites dans les paramètres pour afficher votre trajet préféré.")
            .padding()
            .foregroundColor(.gray)
            .font(.caption)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.init(red: 0.8, green: 0.8, blue: 0.8), lineWidth: 1)
            )
        }
        .padding()
    }
    
    var SettingsButton: some View {
        Button(action: { self.showSettings.toggle() }) {
            Image(systemName: "gear")
            .imageScale(.large)
            .accessibility(label: Text("Paramètres"))
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
                if settings.count > 0 {
                    buildFavoriteJourney()
                }
                if favoriteStations.count >= 0 {
                    List {
                        ForEach(self.stations) { station in
                            if self.favoriteStations.firstIndex(where: { $0.number == station.id }) != nil {
                                StationRow(station: station)
                            }
                        }
                    .onDelete(perform: deleteStation)
                    }
                } else {
                    Text("Ajoutez une station pour commencer")
                        .foregroundColor(.gray)
                }
                Button(action: { self.fetchStations() }) {
                    Text("Rafraichir")
                }
            }
            .navigationBarTitle(Text("Bicloo Quick Look"))
            .navigationBarItems(leading: SettingsButton, trailing: AddButton)
            .background(EmptyView().sheet(isPresented: $showStationList) {
                StationList(showStationList: self.$showStationList, stations: self.stations)
                    .environment(\.managedObjectContext, self.managedObjectContext)
            })
            .background(EmptyView().sheet(isPresented: $showSettings) {
                SettingsView(showSettings: self.$showSettings)
                    .environment(\.managedObjectContext, self.managedObjectContext)
            })
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
