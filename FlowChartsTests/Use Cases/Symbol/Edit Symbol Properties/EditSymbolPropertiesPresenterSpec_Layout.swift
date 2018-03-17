//
//  EditSymbolPropertiesPresenterSpec_Layout.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Quick
import Nimble
import PresenterKit
@testable import FlowCharts

class EditSymbolPropertiesPresenterSpec_Layout: QuickSpec {
    
    override func spec() {
        
        describe("EditSymbolPropertiesPresenter") {
            
            var useCase: TestEditSymbolPropertiesUseCase!
            
            beforeEach {
                useCase = TestEditSymbolPropertiesUseCase()
                useCase.presenter.present(with: .instant())
                useCase.buttonsLayoutManager.editButtonLocations[useCase.ui.presentingView] = CGPoint(x: 42, y: 42)
                useCase.presenter.layout()
            }
            
            it("should layout button") {
                expect(useCase.ui.buttonLocation).to(equal(CGPoint(x: 42, y: 42)))
            }
        }
    }
}
