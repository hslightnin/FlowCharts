//
//  ResizeSymbolPresenterSpec_ChoosingMode.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Quick
import Nimble
import PresenterKit
import DiagramGeometry
@testable import FlowCharts

class ResizeSymbolPresenterSpec_ChoosingMode: QuickSpec {
    
    override func spec() {
        
        describe("ResizeSymbolPresenter") {
            
            var useCase: TestResizeSymbolTestCase!
            
            beforeEach {
                useCase = TestResizeSymbolTestCase()
                useCase.presenter.present(with: .instant())
            }
            
            context("when began choosing mode") {
                
                beforeEach {
                    let transition = Transition.instant()
                    useCase.ui.onBeganChoosingMode?(transition)
                    transition.perform()
                }
                
                it("should activate") {
                    expect(useCase.presenter.isActivated).to(beTrue())
                }
                
                context("when ended choosing mode") {
                    
                    beforeEach {
                        let transition = Transition.instant()
                        useCase.ui.onEndedChoosingMode?(transition)
                        transition.perform()
                    }
                    
                    it("should deactivate") {
                        expect(useCase.presenter.isDeactivated).to(beTrue())
                    }
                }
            }
        }
    }
}
