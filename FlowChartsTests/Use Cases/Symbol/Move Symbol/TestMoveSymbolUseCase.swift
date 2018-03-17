//
//  TestMoveSymbolUseCase.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

@testable import FlowCharts

class TestMoveSymbolUseCase {
    
    var ui: StubMoveSymbolUI!
    var interactor: StubMoveSymbolInteractor!
    var coordinatesConverter: StubCoordinatesConverter!
    var presenter: MoveSymbolPresenter!
    var error: Error?
    
    init() {
        
        ui = StubMoveSymbolUI()
        interactor = StubMoveSymbolInteractor()
        coordinatesConverter = StubCoordinatesConverter()
        
        presenter = MoveSymbolPresenter(
            ui: ui,
            interactor: interactor,
            coordinatesConverter: coordinatesConverter)
        
        error = nil
        presenter.onError = {
            self.error = $0
        }
    }
}
