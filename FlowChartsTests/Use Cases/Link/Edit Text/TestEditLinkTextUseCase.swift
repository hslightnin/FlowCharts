//
//  TestEditLinkTextUseCase.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 10/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

@testable import FlowCharts

class TestEditLinkTextUseCase {
    
    var ui: StubEditTextUI!
    var interactor: StubeEditLinkTextInteractor!
    var buttonsLayoutManager: StubLinkButtonsLayoutManager!
    var coordinatesConverter: StubCoordinatesConverter!
    var presenter: EditLinkTextPresenter!
    var error: Error?
    
    init() {
        
        ui = StubEditTextUI()
        interactor = StubeEditLinkTextInteractor()
        coordinatesConverter = StubCoordinatesConverter()
        buttonsLayoutManager = StubLinkButtonsLayoutManager()
        
        presenter = EditLinkTextPresenter(
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
