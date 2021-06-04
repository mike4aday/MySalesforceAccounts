//
//  MyAccountsLoader.swift
//  MySalesforceAccounts
//
//  Created by Michael Epstein on 6/1/21.
//

import Foundation
import Combine
import SwiftlySalesforce

//
// Adapted from https://www.swiftbysundell.com/articles/handling-loading-states-in-swiftui/
//
class MyAccountsLoader: ObservableObject {
    
    @Published public private(set) var state: LoadingState<QueryResult<SalesforceRecord>> = .idle
    private var cancellable: AnyCancellable?

    public func load() {
        state = .loading
        cancellable = AnyPublisher<ConnectedApp, Error>
            .just(try ConnectedApp())
            .flatMap { $0.myRecords(type: "Account") }
            .map(LoadingState.loaded)
            .catch { error in
                Just(LoadingState.failed(error))
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.state = state
            }
    }
}

public enum LoadingState<Value> {
    case idle
    case loading
    case failed(Error)
    case loaded(Value)
}
