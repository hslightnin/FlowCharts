//
//  TestBuildSymbolUseCase.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

@testable import FlowCharts

class TestBuildSymbolUseCase {
    
    var ui: StubBuildSymbolUI!
    var interactor: StubBuildSymbolInteractor!
    var coordinatesConverter: StubCoordinatesConverter!
    var presenter: BuildSymbolPresenter!
    var error: Error?
    var hasEnded = false
    var hasCancelled = false
    
    init() {
        
        ui = StubBuildSymbolUI()
        interactor = StubBuildSymbolInteractor()
        coordinatesConverter = StubCoordinatesConverter()
        
        presenter = BuildSymbolPresenter(
            ui: ui,
            interactor: interactor,
            coordinatesConverter: coordinatesConverter)
        
        error = nil
        presenter.onError = {
            self.error = $0
        }
        
        hasEnded = false
        presenter.onEnded = {
            self.hasEnded = true
        }
        
        hasCancelled = false
        presenter.onCancelled = {
            self.hasCancelled = true
        }
    }
}
