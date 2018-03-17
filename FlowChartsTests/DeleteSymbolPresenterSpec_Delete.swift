//
//  DeleteSymbolPresenterSpec_Delete.swift
//  FlowChartsTests
//
//  Created by Alexandr Kozlov on 12/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Quick
import Nimble
import PresenterKit
@testable import FlowCharts

class DeleteSymbolPresenterSpec_Delete: QuickSpec {
    
    override func spec() {
        
        describe("DeleteSymbolPresenter") {
            
            var useCase: TestDeleteSymbolUseCase!
            
            beforeEach {
                useCase = TestDeleteSymbolUseCase()
                useCase.presenter.present(with: .instant())
            }
            
            context("when button pressed") {
                
                beforeEach {
                    useCase.ui.onButtonPressed?()
                }
                
                it("should delete symbol") {
                    expect(useCase.interactor.hasDeletedSymbol).to(beTrue())
                }
                
                it("should save") {
                    expect(useCase.interactor.hasSaved).to(beTrue())
                    expect(useCase.interactor.hasRolledBack).to(beFalse())
                }
                
                it("should not deactivate") {
                    expect(useCase.presenter.isActivated).to(beFalse())
                }
                
                it("should fire onDeleted") {
                    expect(useCase.deleteTransition).notTo(beNil())
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
