//
//  EditLinkAnchorPresenterGeneralSpec.swift
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

class EditLinkAnchorPresenterGeneralSpec: QuickSpec {
    
    override func spec() {
        
        describe("EditLinkAnchorPresenter") {
            
            var useCase: TestEditLinkAnchorUseCase!
            
            beforeEach {
                useCase = TestEditLinkAnchorUseCase()
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
                    expect(useCase.ui.isButtonPresented).to(beTrue())
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
