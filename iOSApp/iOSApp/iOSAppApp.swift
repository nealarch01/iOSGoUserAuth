//
//  iOSAppApp.swift
//  iOSApp
//
//  Created by Neal Archival on 12/22/22.
//

import SwiftUI

@main
struct iOSAppApp: App {
    @State private var session: Session = Session()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(session)
        }
    }
}
