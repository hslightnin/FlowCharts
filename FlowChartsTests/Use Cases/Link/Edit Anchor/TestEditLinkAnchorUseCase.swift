//
//  TestEditLinkAnchorUseCase.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 10/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

@testable import FlowCharts

class TestEditLinkAnchorUseCase {
    
    var ui: StubEditLinkAnchorUI!
    var moveInteractor: StubMoveLinkAnchorInteractor!
    var editPropertiesInteractor: StubEditLinkAnchorPropertiesInteractor!
    var buttonsLayoutManager: StubLinkButtonsLayoutManager!
    var coordinatesConverter: StubCoordinatesConverter!
    var presenter: EditLinkAnchorPresenter!
    var error: Error?
    
    init() {
        
        ui = StubEditLinkAnchorUI()
        moveInteractor = StubMoveLinkAnchorInteractor()
        editPropertiesInteractor = StubEditLinkAnchorPropertiesInteractor()
        coordinatesConverter = StubCoordinatesConverter()
        buttonsLayoutManager = StubLinkButtonsLayoutManager()
        
        presenter = EditLinkAnchorPresenter(
            ui: ui,
            moveInteractor: moveInteractor,
            editPropertiesInteractor: editPropertiesInteractor,
            buttonsLayoutManager: buttonsLayoutManager,
            coordinatesConverter: coordinatesConverter)
        
        error = nil
        presenter.onError = {
            self.error = $0
        }
    }
}
