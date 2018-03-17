////
////  DeleteSymbolTests.swift
////  FlowChartsTests
////
////  Created by Alexander Kozlov on 03/03/2018.
////  Copyright © 2018 Brown Coats. All rights reserved.
////
//
//import Quick
//import Nimble
//import PresenterKit
//@testable import FlowCharts
//
//class StubInteractor: DeleteSymbolInteractorProtocol {
//
//    var isDeleted = false
//
//    func delete() {
//        isDeleted = true
//    }
//
//    func save(withIn transition: Transition) throws {
//
//    }
//
//    func rollback(withIn transition: Transition) {
//
//    }
//}
//
//class StubOutlook: FreePresenter, DeleteSymbolUIProtocol {
//
//    var onTap: (() -> Void)?
//
//    func layout() {
//
//    }
//}
//
//class SymbolDeleteUseCaseSpec: QuickSpec {
//
//    override func spec() {
//
//        describe("DeleteSymbolUseCase") {
//
//            var interactor: StubInteractor!
//            var outlook: StubOutlook!
//            var useCasePresenter: DeleteSymbolUseCasePresenter!
//
//            beforeEach {
//                interactor = StubInteractor()
//                outlook = StubOutlook()
//                useCasePresenter = DeleteSymbolUseCasePresenter(interactor: interactor, outlook: outlook)
//            }
//
//            context("when presented") {
//
//                beforeEach {
//                    useCasePresenter.present(with: .instant())
//                }
//
//                it("should present outlook") {
//                    expect(outlook.state).to(equal(PresenterState.presented))
//                }
//
//                context("when button tapped") {
//
//                    beforeEach {
//                        outlook.onTap?()
//                    }
//
//                    it("should delete") {
//                        expect(interactor.isDeleted).to(be(true))
//                    }
//
//                    it("should fire onDelete") {
//                        useCasePresenter.onDelete
//                    }
//                }
//            }
//
//            context("when disposed") {
//
//                weak var weakReference: DeleteSymbolUseCasePresenter!
//
//                beforeEach {
//                    weakReference = useCasePresenter
//                }
//
//                it("should not create reference cycles") {
//                    useCasePresenter = nil
//                    expect(weakReference).to(beNil())
//                }
//            }
//        }
//    }
//}
//
