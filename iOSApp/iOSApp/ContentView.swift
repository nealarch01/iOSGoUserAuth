//
//  ContentView.swift
//  iOSApp
//
//  Created by Neal Archival on 12/22/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: Session
    var body: some View {
        ZStack {
            if session.token == "" {
                AuthView()
            } else {
                HomeView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Session())
    }
}
