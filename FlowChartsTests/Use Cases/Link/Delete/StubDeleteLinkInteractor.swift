//
//  StubDeleteLinkInteractor.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 10/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

@testable import FlowCharts

class StubDeleteLinkInteractor: StubInteractor, DeleteLinkInteractorProtocol {
    
    var hasDeletedLink = false
    
    func deleteLink() {
        hasDeletedLink = true
    }
}
