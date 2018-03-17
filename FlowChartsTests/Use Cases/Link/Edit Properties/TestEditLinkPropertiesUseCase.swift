//
//  TestEditLinkPropertiesUseCase.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 10/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

@testable import FlowCharts

class TestEditLinkPropertiesUseCase {
    
    var ui: StubEditLinkPropertiesUI!
    var interactor: StubEditLinkPropertiesInteractor!
    var buttonsLayoutManager: StubLinkButtonsLayoutManager!
    var coordinatesConverter: StubCoordinatesConverter!
    var presenter: EditLinkPropertiesPresenter!
    var error: Error?
    
    init() {
        
        ui = StubEditLinkPropertiesUI()
        interactor = StubEditLinkPropertiesInteractor()
        coordinatesConverter = StubCoordinatesConverter()
        buttonsLayoutManager = StubLinkButtonsLayoutManager()
        
        presenter = EditLinkPropertiesPresenter(
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
