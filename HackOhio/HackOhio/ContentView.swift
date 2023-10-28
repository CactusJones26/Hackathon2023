//
//  ContentView.swift
//  HackOhio
//
//  Created by Kevin Dong on 10/28/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
            TabView {
                // Activate page
                Text("This is the first page")
                    .tabItem {
                        Label("Activate", systemImage: "1.circle.fill")
                    }
                    .tag(0)

                // Stat page
                Text("This is the second page")
                    .tabItem {
                        Label("Statistics", systemImage: "2.circle.fill")
                    }
                    .tag(1)

                // Calibrate page
                Text("This is the third page")
                    .tabItem {
                        Label("Calibrate", systemImage: "3.circle.fill")
                    }
                    .tag(2)

                // Account page
                Text("This is the fourth page")
                    .tabItem {
                        Label("Account", systemImage: "4.circle.fill")
                    }
                    .tag(3)
            }
        }
}

#Preview {
    ContentView()
}
