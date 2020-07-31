//
//  SettingsView.swift
//  BiclooQuickLookiOS
//
//  Created by Pierre Lavalley on 30/07/2020.
//  Copyright © 2020 Pierre Lavalley. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: StoredStation.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \StoredStation.number, ascending: true)]
    ) var favoriteStations: FetchedResults<StoredStation>
    @FetchRequest(
        entity: Settings.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Settings.objectID, ascending: true)]
    ) var settings: FetchedResults<Settings>
    @Binding var showSettings: Bool
    @State private var favStation: Int16 = 0
    @State private var favBegStation: Int16 = 0
    @State private var favEndStation: Int16 = 0
    @State private var hasAppeared = false
    
    func load() {
        if self.hasAppeared == false {
            print("Appear")
            // Fill state with saved data
            if settings.count != 0 {
                self.favStation = settings[0].favoriteStation
                self.favBegStation = settings[0].favBegStation
                self.favEndStation = settings[0].favEndStation
            }
            self.hasAppeared = true
        }
    }
    
    func save() {
        let stgs: Settings
        if settings.count == 0 {
            // Create settings
            print("Create settings")
            stgs = Settings(context: AppDelegate.viewContext)
        } else {
            // Update existing settings
            print("Update settings")
            stgs = settings[0]
        }
        
        stgs.favoriteStation = self.favStation
        stgs.favBegStation = self.favBegStation
        stgs.favEndStation = self.favEndStation

        // Save settings
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Error while saving settings: \(error)")
        }
        
        self.showSettings = false
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Station préférée"), footer: Text("Définir une station prérérée vous permet de voir rapidement le nombre de vélos disponibles.")) {
                    if self.favoriteStations.count > 0 {
                        Picker(selection: $favStation, label: Text("Station préférée")) {
                            ForEach(self.favoriteStations, id: \.number) { station in
                                Text(station.name ?? "None")
                            }
                        }
                    } else {
                        Text("Ajoutez au moins 1 station pour définir votre station préféréé")
                        .foregroundColor(.gray)
                        .padding(.vertical, 5)
                    }
                }
                Section(header: Text("Trajet préféré")) {
                    if self.favoriteStations.count >= 2 {
                        Picker(selection: $favBegStation, label: Text("Station de départ")) {
                            ForEach(self.favoriteStations.filter { $0.number != favEndStation }, id: \.number) { station in
                                Text(station.name ?? "None")
                            }
                        }
                        Picker(selection: $favEndStation, label: Text("Station d'arrivée")) {
                            ForEach(self.favoriteStations.filter { $0.number != favBegStation }, id: \.number) { station in
                                Text(station.name ?? "None")
                            }
                        }
                    } else {
                        Text("Ajoutez au moins 2 stations pour définir votre trajet préféré")
                            .foregroundColor(.gray)
                            .padding(.vertical, 5)
                    }
                }
            }
            .onAppear(perform: { self.load() })
            .navigationBarTitle(Text("Paramètres"), displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: { self.save() }) {
                    Text("OK")
                })
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSettings: .constant(true)).environment(\.managedObjectContext, AppDelegate.viewContext)
    }
}
