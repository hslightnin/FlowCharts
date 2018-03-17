//
//  TestDeleteSymbolUseCase.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit
@testable import FlowCharts

class TestDeleteSymbolUseCase {
    
    var ui: StubDeleteUI!
    var interactor: StubDeleteSymbolInteractor!
    var buttonsLayoutManager: StubSymbolButtonsLayoutManager!
    var coordinatesConverter: StubCoordinatesConverter!
    var presenter: DeleteSymbolPresenter!
    var error: Error?
    var deleteTransition: Transition?
    
    init() {
        
        ui = StubDeleteUI()
        interactor = StubDeleteSymbolInteractor()
        coordinatesConverter = StubCoordinatesConverter()
        buttonsLayoutManager = StubSymbolButtonsLayoutManager()
        
        presenter = DeleteSymbolPresenter(
            ui: ui,
            interactor: interactor,
            buttonsLayoutManager: buttonsLayoutManager)
        
        error = nil
        presenter.onError = {
            self.error = $0
        }
        
        deleteTransition = nil
        presenter.onDeleted = {
            self.deleteTransition = $0
        }
    }
}
