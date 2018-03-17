//
//  TestEditSymbolTextUseCase.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

@testable import FlowCharts

class TestEditSymbolTextUseCase {
    
    var ui: StubEditTextUI!
    var interactor: StubEditSymbolTextInteractor!
    var buttonsLayoutManager: StubSymbolButtonsLayoutManager!
    var coordinatesConverter: StubCoordinatesConverter!
    var presenter: EditSymbolTextPresenter!
    var error: Error?
    
    init() {
        
        ui = StubEditTextUI()
        interactor = StubEditSymbolTextInteractor()
        coordinatesConverter = StubCoordinatesConverter()
        buttonsLayoutManager = StubSymbolButtonsLayoutManager()
        
        presenter = EditSymbolTextPresenter(
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
