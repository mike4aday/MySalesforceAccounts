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
    
    @StateObject private var loader = MyAccountsLoader()
        
    var body: some View {
        switch loader.state {
        case .idle:
            Color.clear.onAppear(perform: loader.load)
        case .loading:
            ProgressView()
        case .failed(let error):
            ErrorView(error: error, retry: loader.load)
        case .loaded(let output):
            QueryResultView(queryResult: output)
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
