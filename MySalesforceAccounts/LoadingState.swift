//
//  LoadingStyle.swift
//  MySalesforceAccounts
//
//  Created by Michael Epstein on 3/27/22.
//

import Foundation

public enum LoadingState<Value> {
    case idle
    case loading
    case failed(Error)
    case loaded(Value)
}
