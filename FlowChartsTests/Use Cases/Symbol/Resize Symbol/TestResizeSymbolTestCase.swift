//
//  TestResizeSymbolTestCase.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

@testable import FlowCharts

class TestResizeSymbolTestCase {
    
    var ui: StubResizeSymbolUI!
    var interactor: StubResizeSymbolInteractor!
    var buttonsLayoutManager: StubSymbolButtonsLayoutManager!
    var coordinatesConverter: StubCoordinatesConverter!
    var presenter: ResizeSymbolPresenter!
    var error: Error?
    
    init() {
        
        ui = StubResizeSymbolUI()
        interactor = StubResizeSymbolInteractor()
        coordinatesConverter = StubCoordinatesConverter()
        buttonsLayoutManager = StubSymbolButtonsLayoutManager()
        
        presenter = ResizeSymbolPresenter(
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
