//
//  EditSymbolTextPresenterSpec.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 08/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Quick
import Nimble
import PresenterKit
import DiagramGeometry
@testable import FlowCharts

class EditSymbolTextPresenterSpec: QuickSpec {
    
    override func spec() {
        
        describe("EditSymbolTextPresenter") {
            
            var ui: StubEditTextUI!
            var interactor: StubEditSymbolTextInteractor!
            var coordinatesConverter: StubCoordinatesConverter!
            var buttonsLayoutManager: StubSymbolButtonsLayoutManager!
            var presenter: EditSymbolTextPresenter!
            var error: Error?
            
            beforeEach {
                ui = StubEditTextUI()
                ui.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                interactor = StubEditSymbolTextInteractor()
                interactor.textInsets = Vector(2, 3)
                interactor.text = "Initial Text"
                interactor.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
                coordinatesConverter = StubCoordinatesConverter()
                buttonsLayoutManager = StubSymbolButtonsLayoutManager()
                presenter = EditSymbolTextPresenter(
                    ui: ui,
                    interactor: interactor,
                    buttonsLayoutManager: buttonsLayoutManager,
                    coordinatesConverter: coordinatesConverter)
                error = nil
                presenter.onError = {
                    error = $0
                }
            }
            
            it("should not create reference cycles") {
                weak var weakPresenter = presenter
                presenter = nil
                expect(weakPresenter).to(beNil())
            }
            
            describe("interactions") {
                
                context("when presented") {
                    
                    beforeEach {
                        presenter.present(with: .instant())
                    }
                    
                    it("should present button") {
                        expect(ui.isButtonPresented).to(beTrue())
                    }
                    
                    it("should present double tap") {
                        expect(ui.isDoubleTapPresented).to(beTrue())
                    }
                    
                    context("when button tapped") {
                        
                        beforeEach {
                            ui.onButtonPressed?()
                        }
                        
                        it("should activate") {
                            expect(presenter.isActivated).to(beTrue())
                        }
                        
                        it("should hide text") {
                            expect(interactor.text).to(beNil())
                        }
                        
                        it("should update ui properties") {
                            expect(ui.text).to(equal("Initial Text"))
                            expect(ui.font).to(equal(interactor.font))
                            expect(ui.textInsets).to(equal(UIEdgeInsets(top: 3, left: 2, bottom: 3, right: 2)))
                        }
                        
                        it("should update ui") {
                            expect(ui.isButtonPresented).to(beFalse())
                            expect(ui.isDoubleTapPresented).to(beFalse())
                            expect(ui.isTextViewPresented).to(beTrue())
                            expect(ui.isCancelTapPresented).to(beTrue())
                        }
                    }
                    
                    context("when double tap recognized") {
                        
                        beforeEach {
                            ui.onDoubleTapRecognized?()
                        }
                        
                        it("should activate") {
                            expect(presenter.isActivated).to(beTrue())
                        }
                        
                        it("should hide text") {
                            expect(interactor.text).to(beNil())
                        }
                        
                        it("should update ui properties") {
                            expect(ui.text).to(equal("Initial Text"))
                            expect(ui.font).to(equal(interactor.font))
                            expect(ui.textInsets).to(equal(UIEdgeInsets(top: 3, left: 2, bottom: 3, right: 2)))
                        }
                        
                        it("should update ui") {
                            expect(ui.isButtonPresented).to(beFalse())
                            expect(ui.isDoubleTapPresented).to(beFalse())
                            expect(ui.isTextViewPresented).to(beTrue())
                            expect(ui.isCancelTapPresented).to(beTrue())
                        }
                    }

                    context("when activated") {
                        
                        beforeEach {
                            ui.onButtonPressed?()
                        }
                        
                        context("when text view ended editing and save succeeded") {
                            
                            beforeEach {
                                interactor.saveSucceeds = true
                                ui.text = "Edited Text"
                                ui.onTextViewEndedEditing?()
                            }
                            
                            it("should deactivate") {
                                expect(presenter.isDeactivated).to(beTrue())
                            }
                            
                            it("should save text") {
                                expect(interactor.text).to(equal("Edited Text"))
                                expect(interactor.hasSaved).to(beTrue())
                                expect(interactor.hasRolledBack).to(beFalse())
                            }
                            
                            it("should update ui") {
                                expect(ui.isButtonPresented).to(beTrue())
                                expect(ui.isDoubleTapPresented).to(beTrue())
                                expect(ui.isTextViewPresented).to(beFalse())
                                expect(ui.isCancelTapPresented).to(beFalse())
                            }
                        }
                        
                        context("when ended editing text and save failed") {
                            
                            beforeEach {
                                interactor.saveSucceeds = false
                                ui.text = "Edited Text"
                                ui.onTextViewEndedEditing?()
                            }
                            
                            it("should not deactivate") {
                                expect(presenter.isDeactivated).to(beFalse())
                            }
                            
                            it("should rollback text") {
                                expect(interactor.hasSaved).to(beTrue())
                                expect(interactor.hasRolledBack).to(beTrue())
                            }
                            
                            it("should file onError") {
                                expect(error).notTo(beNil())
                            }
                            
                            it("should not update ui") {
                                expect(ui.isButtonPresented).to(beFalse())
                                expect(ui.isDoubleTapPresented).to(beFalse())
                                expect(ui.isTextViewPresented).to(beTrue())
                                expect(ui.isCancelTapPresented).to(beTrue())
                            }
                            
                            context("when dismissed") {
                                
                                beforeEach {
                                    presenter.dismiss(with: .instant())
                                }
                                
                                it("should dismiss ui") {
                                    expect(ui.isButtonPresented).to(beFalse())
                                    expect(ui.isDoubleTapPresented).to(beFalse())
                                    expect(ui.isTextViewPresented).to(beFalse())
                                    expect(ui.isCancelTapPresented).to(beFalse())
                                }
                            }
                        }
                        
                        context("when cancel tap recognized and save succeeds") {
                            
                            beforeEach {
                                interactor.saveSucceeds = true
                                ui.text = "Edited Text"
                                ui.onCancelTapRecognized?()
                            }
                            
                            it("should deactivate") {
                                expect(presenter.isDeactivated).to(beTrue())
                            }
                            
                            it("should save text") {
                                expect(interactor.text).to(equal("Edited Text"))
                                expect(interactor.hasSaved).to(beTrue())
                                expect(interactor.hasRolledBack).to(beFalse())
                            }
                            
                            it("should update ui") {
                                expect(ui.isButtonPresented).to(beTrue())
                                expect(ui.isDoubleTapPresented).to(beTrue())
                                expect(ui.isTextViewPresented).to(beFalse())
                                expect(ui.isCancelTapPresented).to(beFalse())
                            }
                        }
                        
                        context("when cancel tap recognized and save failed") {
                            
                            beforeEach {
                                interactor.saveSucceeds = false
                                ui.text = "Edited Text"
                                ui.onCancelTapRecognized?()
                            }
                            
                            it("should not deactivate") {
                                expect(presenter.isDeactivated).to(beFalse())
                            }
                            
                            it("should rollback text") {
                                expect(interactor.hasSaved).to(beTrue())
                                expect(interactor.hasRolledBack).to(beTrue())
                            }
                            
                            it("should file onError") {
                                expect(error).notTo(beNil())
                            }
                            
                            it("should not update ui") {
                                expect(ui.isButtonPresented).to(beFalse())
                                expect(ui.isDoubleTapPresented).to(beFalse())
                                expect(ui.isTextViewPresented).to(beTrue())
                                expect(ui.isCancelTapPresented).to(beTrue())
                            }
                            
                            context("when dismissed") {
                                
                                beforeEach {
                                    presenter.dismiss(with: .instant())
                                }
                                
                                it("should dismiss ui") {
                                    expect(ui.isButtonPresented).to(beFalse())
                                    expect(ui.isDoubleTapPresented).to(beFalse())
                                    expect(ui.isTextViewPresented).to(beFalse())
                                    expect(ui.isCancelTapPresented).to(beFalse())
                                }
                            }
                        }
                        
                        context("when cancelled editing text") {
                            
                            beforeEach {
                                ui.text = "Edited Text"
                                ui.onTextViewCancelledEditing?()
                            }
                            
                            it("should deactivate") {
                                expect(presenter.isDeactivated).to(beTrue())
                            }
                            
                            it("should rollback text") {
                                expect(interactor.hasSaved).to(beFalse())
                                expect(interactor.hasRolledBack).to(beTrue())
                            }
                            
                            it("should update ui") {
                                expect(ui.isButtonPresented).to(beTrue())
                                expect(ui.isDoubleTapPresented).to(beTrue())
                                expect(ui.isTextViewPresented).to(beFalse())
                                expect(ui.isCancelTapPresented).to(beFalse())
                            }
                        }
                    }
                    
                    context("when dismissed") {
                        
                        beforeEach {
                            presenter.dismiss(with: .instant())
                        }
                        
                        it("should dismiss ui") {
                            expect(ui.isButtonPresented).to(beFalse())
                            expect(ui.isDoubleTapPresented).to(beFalse())
                            expect(ui.isTextViewPresented).to(beFalse())
                            expect(ui.isCancelTapPresented).to(beFalse())
                        }
                    }
                }
            }
            
            describe("layout") {

                beforeEach {
                    buttonsLayoutManager.editTextButtonLocations[ui.presentingView] = CGPoint(x: 42, y: 42)
                    presenter.layout()
                }

                it("should layout button") {
                    expect(ui.buttonLocation).to(equal(CGPoint(x: 42, y: 42)))
                }
                
                it("should layout textView") {
                    expect(ui.textViewLocation).to(equal(CGPoint(x: 50, y: 50)))
                    expect(ui.textViewWidth).to(equal(100))
                }
            }
        }
    }
}
