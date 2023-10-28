//
//  HackOhioApp.swift
//  HackOhio
//
//  Created by Kevin Dong on 10/28/23.
//

import SwiftUI

@main
struct HackOhioApp: App {
    @AppStorage("isUserLoggedIn") private var isUserLoggedIn = false
    var body: some Scene {
        WindowGroup {
            if isUserLoggedIn {
                ActivationView()
            } else {
                LoginView()
            }
            
            //GlobalNavigationView()
        }
    }
}
