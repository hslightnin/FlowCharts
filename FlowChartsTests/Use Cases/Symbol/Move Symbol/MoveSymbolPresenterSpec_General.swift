//
//  MoveSymbolPresenterSpec_General.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Quick
import Nimble
import PresenterKit
@testable import FlowCharts

class MoveSymbolPresenterSpec_General: QuickSpec {
    
    override func spec() {
        
        describe("MoveSymbolPresenter") {
            
            var useCase: TestMoveSymbolUseCase!
            
            beforeEach {
                useCase = TestMoveSymbolUseCase()
            }
            
            it("should not create reference cycles") {
                weak var weakPresenter = useCase.presenter
                useCase.presenter = nil
                expect(weakPresenter).to(beNil())
            }
            
            context("when presented") {
                
                beforeEach {
                    useCase.presenter.present(with: .instant())
                }
                
                it("should present pan") {
                    expect(useCase.ui.isPanPresented).to(beTrue())
                }
                
                context("when dismissed") {
                    
                    beforeEach {
                        useCase.presenter.dismiss(with: .instant())
                    }
                    
                    it("should dismiss pan") {
                        expect(useCase.ui.isPanPresented).to(beFalse())
                    }
                }
            }
        }
    }
}
