//
//  DeleteLinkPresenterSpec_DeleteError.swift
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

class DeleteLinkPresenterSpec_DeleteError: QuickSpec {
    
    override func spec() {
        
        describe("DeleteLinkPresenter") {
            
            var useCase: TestDeleteLinkUseCase!
            
            beforeEach {
                useCase = TestDeleteLinkUseCase()
                useCase.presenter.present(with: .instant())
                useCase.interactor.saveFails = true
            }
            
            context("when button pressed") {
                
                beforeEach {
                    useCase.ui.onButtonPressed?()
                }
                
                it("should delete link") {
                    expect(useCase.interactor.hasDeletedLink).to(beTrue())
                }
                
                it("should try save and rollback ") {
                    expect(useCase.interactor.hasSaved).to(beTrue())
                    expect(useCase.interactor.hasRolledBack).to(beTrue())
                }
                
                it("should not deactivate") {
                    expect(useCase.presenter.isActivated).to(beFalse())
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
