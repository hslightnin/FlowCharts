//
//  TestBuildLinkUseCase.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

@testable import FlowCharts

class TestBuildLinkUseCase {
    
    var ui: StubBuildLinkUI!
    var interactor: StubBuildLinkInteractor!
    var buttonsLayoutManager: StubSymbolButtonsLayoutManager!
    var coordinatesConverter: StubCoordinatesConverter!
    var presenter: BuildLinkPresenter!
    var error: Error?
    var hasEnded = false
    
    init() {
        
        ui = StubBuildLinkUI()
        interactor = StubBuildLinkInteractor()
        coordinatesConverter = StubCoordinatesConverter()
        buttonsLayoutManager = StubSymbolButtonsLayoutManager()
        
        presenter = BuildLinkPresenter(
            ui: ui,
            interactor: interactor,
            buttonsLayoutManager: buttonsLayoutManager,
            coordinatesConverter: coordinatesConverter)
        
        error = nil
        presenter.onError = {
            self.error = $0
        }
        
        hasEnded = false
        presenter.onEnded = {
            self.hasEnded = true
        }
    }
}
