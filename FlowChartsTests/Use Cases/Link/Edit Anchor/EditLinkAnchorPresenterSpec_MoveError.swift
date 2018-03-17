//
//  EditLinkAnchorPresenterMoveErrorSpec.swift
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

class EditLinkAnchorPresenterMoveErrorSpec: QuickSpec {
    
    override func spec() {
        
        describe("EditLinkAnchorPresenter") {
            
            var useCase: TestEditLinkAnchorUseCase!
            
            beforeEach {
                useCase = TestEditLinkAnchorUseCase()
            }
            
            context("when save fails") {
                
                beforeEach {
                    useCase.moveInteractor.canSave = true
                    useCase.moveInteractor.saveFails = true
                }
                
                context("when pan ended") {
                    
                    beforeEach {
                        useCase.presenter.present(with: .instant())
                        useCase.ui.onPanBegan?()
                        useCase.ui.onPanMoved?(CGPoint(x: 1, y: 1), useCase.ui.presentingView)
                        useCase.ui.onPanEnded?()
                    }
                    
                    it("should try save and rollback") {
                        expect(useCase.moveInteractor.hasSaved).to(beTrue())
                        expect(useCase.moveInteractor.hasRolledBack).to(beTrue())
                    }
                    
                    it("should not deacivate") {
                        expect(useCase.presenter.isActivated).to(beTrue())
                    }
                    
                    it("should fire onError") {
                        expect(useCase.error).notTo(beNil())
                    }
                    
                    context("when dismissed") {
                        
                        beforeEach {
                            useCase.presenter.dismiss(with: .instant())
                        }
                        
                        it("should dismiss pan") {
                            expect(useCase.ui.isButtonPresented).to(beFalse())
                        }
                    }
                }
            }
        }
    }
}
