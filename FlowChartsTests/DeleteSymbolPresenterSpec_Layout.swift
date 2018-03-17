//
//  DeleteSymbolPresenterSpec_Layout.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Quick
import Nimble
import PresenterKit
@testable import FlowCharts

class DeleteSymbolPresenterSpec_Layout: QuickSpec {
    
    override func spec() {
        
        describe("DeleteSymbolPresenter") {
            
            var useCase: TestDeleteSymbolUseCase!
            let expectedLocation = CGPoint(x: 42, y: 42)
            
            beforeEach {
                useCase = TestDeleteSymbolUseCase()
                useCase.buttonsLayoutManager.deleteButtonLocations[useCase.ui.presentingView] = expectedLocation
            }
            
            context("when layout") {
                
                beforeEach {
                    useCase.ui.layout()
                }
                
                it("should set button location") {
                    expect(useCase.ui.buttonLocation).to(equal(expectedLocation))
                }
            }
        }
    }
}
