//
//  EditSymbolTextPresenterSpec_General.swift
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

class EditSymbolTextPresenterSpec_General: QuickSpec {
    
    override func spec() {
        
        describe("EditSymbolTextPresenter") {
            
            var useCase: TestEditSymbolTextUseCase!
            
            beforeEach {
                useCase = TestEditSymbolTextUseCase()
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
                
                it("should present button") {
                    expect(useCase.ui.isButtonPresented).to(beTrue())
                }
                
                it("should present double tap") {
                    expect(useCase.ui.isDoubleTapPresented).to(beTrue())
                }
                
                context("when dismissed") {
                    
                    beforeEach {
                        useCase.presenter.dismiss(with: .instant())
                    }
                    
                    it("should present button") {
                        expect(useCase.ui.isButtonPresented).to(beFalse())
                    }
                    
                    it("should present double tap") {
                        expect(useCase.ui.isDoubleTapPresented).to(beFalse())
                    }
                }
            }
        }
    }
}
