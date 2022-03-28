//
//  ContentView.swift
//  MySalesforceAccounts
//
//  Created by Michael Epstein on 6/1/21.
//

import SwiftUI
import SwiftlySalesforce

struct ContentView: View {
    
    @StateObject var salesforce: Connection = try! Salesforce.connect()
    @State var state: LoadingState<[SalesforceRecord]> = .idle
        
    var body: some View {
        switch state {
        case .idle:
            Color.clear
            .task {
                await load()
            }
        case .loading:
            ProgressView()
        case .failed(let error):
            ErrorView(error: error, retry: { await load() })
        case .loaded(let records):
            AsyncButton(action: load) {
                HStack {
                    AsyncButton(systemImageName: "arrow.clockwise", action: load)
                    Text("Loaded: \(Date().formatted(date: .abbreviated, time: .standard))")
                }
            }
            RecordsView(records: records)
        }
    }
}

extension ContentView {
    
    struct RecordsView: View {
        var records: [SalesforceRecord]
        var body: some View {
            List(records, id: \.id) { account in
                VStack(alignment: .leading) {
                    Text(account["Name"] ?? "N/A").bold()
                    Text("ID: \(account.id)")
                    Text("Billing City: \(account["BillingCity"] ?? "N/A")")
                }.padding()
            }
        }
    }
}

extension ContentView {
    
    func load() async {
        state = .loading
        Task {
            do {
                let queryResults = try await salesforce.myRecords(type: "Account", fields: ["Id", "Name", "BillingCity"])
                state = .loaded(queryResults.records)
            }
            catch {
                state = .failed(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


