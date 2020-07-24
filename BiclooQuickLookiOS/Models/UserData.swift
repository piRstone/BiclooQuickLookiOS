//
//  UserData.swift
//  BiclooQuickLookiOS
//
//  Created by Pierre Lavalley on 24/07/2020.
//  Copyright © 2020 Pierre Lavalley. All rights reserved.
//

import SwiftUI
import Combine

final class UserData: ObservableObject {
    @Published var stations = stationData
}
