//
//  DeleteSymbolPresenterSpec_DeleteError.swift
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

class DeleteSymbolPresenterSpec_DeleteError: QuickSpec {
    
    override func spec() {
        
        describe("DeleteSymbolPresenter") {
            
            var useCase: TestDeleteSymbolUseCase!
            
            beforeEach {
                useCase = TestDeleteSymbolUseCase()
                useCase.presenter.present(with: .instant())
                useCase.interactor.saveFails = true
            }
            
            context("when button pressed") {
                
                beforeEach {
                    useCase.ui.onButtonPressed?()
                }
                
                it("should delete link") {
                    expect(useCase.interactor.hasDeletedSymbol).to(beTrue())
                }
                
                it("should try save and rollback") {
                    expect(useCase.interactor.hasSaved).to(beTrue())
                    expect(useCase.interactor.hasRolledBack).to(beTrue())
                }
                
                it("should fire onError") {
                    expect(useCase.error).notTo(beNil())
                }
                
                context("when dismissed") {
                    
                    beforeEach {
                        useCase.presenter.dismiss(with: .instant())
                    }
                    
                    it("should present button") {
                        expect(useCase.ui.isButtonPresented).to(beFalse())
                    }
                }
            }
        }
    }
}
