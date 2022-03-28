//
//  MySalesforceAccountsApp.swift
//  MySalesforceAccounts
//
//  Created by Michael Epstein on 6/1/21.
//

import SwiftUI
import SwiftlySalesforce

@main
struct MySalesforceAccountsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(try! Salesforce.connect())
        }
    }
}
