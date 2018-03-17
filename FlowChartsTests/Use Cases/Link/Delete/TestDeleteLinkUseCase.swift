//
//  TestDeleteLinkUseCase.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 10/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit
@testable import FlowCharts

class TestDeleteLinkUseCase {
    
    var ui: StubDeleteUI!
    var interactor: StubDeleteLinkInteractor!
    var buttonsLayoutManager: StubLinkButtonsLayoutManager!
    var presenter: DeleteLinkPresenter!
    var error: Error?
    var deleteTransition: Transition?
    
    init() {
        
        ui = StubDeleteUI()
        interactor = StubDeleteLinkInteractor()
        buttonsLayoutManager = StubLinkButtonsLayoutManager()
        
        presenter = DeleteLinkPresenter(
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
