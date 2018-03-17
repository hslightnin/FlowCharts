//
//  StubDeleteSymbolInteractor.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

@testable import FlowCharts

class StubDeleteSymbolInteractor: StubInteractor, DeleteSymbolInteractorProtocol {
    
    var hasDeletedSymbol = false
    
    func delete() {
        hasDeletedSymbol = true
    }
}
