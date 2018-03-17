//
//  TestEditSymbolPropertiesUseCase.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

@testable import FlowCharts

class TestEditSymbolPropertiesUseCase {
    
    var ui: StubEditSymbolPropertiesUI!
    var interactor: StubEditSymbolPropertiesInteractor!
    var buttonsLayoutManager: StubSymbolButtonsLayoutManager!
    var coordinatesConverter: StubCoordinatesConverter!
    var presenter: EditSymbolPropertiesPresenter!
    var error: Error?
    
    init() {
        
        ui = StubEditSymbolPropertiesUI()
        interactor = StubEditSymbolPropertiesInteractor()
        coordinatesConverter = StubCoordinatesConverter()
        buttonsLayoutManager = StubSymbolButtonsLayoutManager()
        
        presenter = EditSymbolPropertiesPresenter(
            ui: ui,
            interactor: interactor,
            buttonsLayoutManager: buttonsLayoutManager,
            coordinatesConverter: coordinatesConverter)
        
        error = nil
        presenter.onError = {
            self.error = $0
        }
    }
}
