//
//  ErrorView.swift
//  MySalesforceAccounts
//
//  Created by Michael Epstein on 6/1/21.
//

import SwiftUI

struct ErrorView: View {
    
    var error: Error
    var retry: () -> ()
    
    init(error: Error, retry: @escaping () -> ()) {
        self.error = error
        self.retry = retry
    }
    
    var body: some View {
        VStack(spacing: 6) {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            Text("Error")
                .bold()
            Text(error.localizedDescription)
            Button("Try Again") {
                retry()
            }
            Spacer()
        }
        .padding()
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        let error = URLError(.badURL)
        let retry = { debugPrint("Hello World!") }
        ErrorView(error: error, retry: retry)
    }
}
