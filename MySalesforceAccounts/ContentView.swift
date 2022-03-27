//
//  ContentView.swift
//  MySalesforceAccounts
//
//  Created by Michael Epstein on 6/1/21.
//

import SwiftUI
import Combine
import SwiftlySalesforce

struct ContentView: View {
    
    @StateObject var salesforce: Connection = try! Salesforce.connect()
    @State var state: LoadingState<QueryResult<SalesforceRecord>> = .idle
        
    var body: some View {
        switch state {
        case .idle:
            Color.clear
            .task {
                do {
                    let results = try await salesforce.myRecords(type: "Account", fields: ["Id", "Name", "BillingCity"])
                    state = .loaded(results)
                }
                catch {
                    state = .failed(error)
                }
            }
        case .loading:
            ProgressView()
        case .failed(let error):
            ErrorView(error: error, retry: { print("TODO") })
        case .loaded(let queryResult):
            QueryResultView(queryResult: queryResult)
        }
    }
}

extension ContentView {
    
    struct QueryResultView: View {        
        var queryResult: QueryResult<SalesforceRecord>
        var body: some View {
            List(queryResult.records, id: \.id) { account in
                VStack(alignment: .leading) {
                    Text(account["Name"] ?? "N/A").bold()
                    Text("ID: \(account.id)")
                    Text("Billing City: \(account["BillingCity"] ?? "N/A")")
                }.padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


