//
//  DeleteLinkPresenterSpec_Layout.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 10/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Quick
import Nimble
import PresenterKit
import DiagramGeometry
@testable import FlowCharts

class DeleteLinkPresenterSpec_Layout: QuickSpec {
    
    override func spec() {
        
        describe("DeleteLinkPresenter") {
            
            var useCase: TestDeleteLinkUseCase!
            let expectedLocation = CGPoint(x: 42, y: 42)
            
            beforeEach {
                useCase = TestDeleteLinkUseCase()
                useCase.buttonsLayoutManager.deleteButtonLocations[useCase.ui.presentingView] = expectedLocation
                useCase.presenter.present(with: .instant())
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

