//
//  SymbolMission.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 14/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import DiagramGeometry
import DiagramView
import PresenterKit

protocol DeleteSymbolUseCaseProtocol: class {
    var presenter: ActivatablePresenter & UseCasePresenterProtocol { get }
    var onDeleted: ((Transition) -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
}

protocol MoveSymbolUseCaseProtocol: class {
    var presenter: ActivatablePresenter & UseCasePresenterProtocol { get }
    var onError: ((Error) -> Void)? { get set }
}

protocol EditSymbolTextUseCaseProtocol: class {
    var presenter: ActivatablePresenter & UseCasePresenterProtocol { get }
    var onError: ((Error) -> Void)? { get set }
}

protocol EditSymbolPropertiesUseCaseProtocol: class {
    var presenter: ActivatablePresenter & UseCasePresenterProtocol { get }
    var onError: ((Error) -> Void)? { get set }
}

protocol ResizeSymbolUseCaseProtocol: class {
    var presenter: ActivatablePresenter & UseCasePresenterProtocol { get }
    var onError: ((Error) -> Void)? { get set }
}

protocol BuildLinkUseCaseProtocol: class {
    var presenter: ActivatablePresenter & UseCasePresenterProtocol { get }
    var onEnded: ((FlowChartLink, FlowChartSymbol?) -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
}

protocol SymbolButtonsLayoutManagerProtocol {
    func deleteButtonLocation(in view: UIView) -> CGPoint
    func editTextButtonLocation(in view: UIView) -> CGPoint
    func editPropertiesButtonLocation(in view: UIView) -> CGPoint
    func resizeButtonLocation(in view: UIView) -> CGPoint
    func buildTopLinkButtonLocation(in view: UIView) -> CGPoint
    func buildBottomLinkButtonLocation(in view: UIView) -> CGPoint
    func buildRightLinkButtonLocation(in view: UIView) -> CGPoint
    func buildLeftLinkButtonLocation(in view: UIView) -> CGPoint
}

class SymbolMission: SymbolMissionProtocol {
    
    let symbol: FlowChartSymbol
    let diagramViewController: DiagramViewController
    
    var onAdded: ((FlowChartLink, FlowChartSymbol?) -> Void)?
    var onDeleted: ((Transition) -> Void)?
    var onError: ((Error) -> Void)?
    
    init(symbol: FlowChartSymbol, diagramViewController: DiagramViewController) {
        self.symbol = symbol
        self.diagramViewController = diagramViewController
    }
    
    lazy var presenter: ActivatablePresenter = {
        
        let presenters: [ActivatablePresenter & UseCasePresenterProtocol] = [
            self.moveUseCase.presenter,
            self.deleteUseCase.presenter,
            self.editTextUseCase.presenter,
            self.resizeUseCase.presenter,
            self.editProperties.presenter,
            self.buildTopLinkUseCase.presenter,
            self.buildBottomLinkUseCase.presenter,
            self.buildRightLinkUseCase.presenter,
            self.buildLeftLinkUseCase.presenter
        ]
        
        let layoutObserver = SymbolLayoutObserver(
            symbol: self.symbol,
            diagramViewController: self.diagramViewController)
        
        let interactor = SymbolMissionInteractor(symbol: self.symbol)
        
        return SymbolMissionPresenter(
            presenters: presenters,
            interactor: interactor,
            layoutObserver: layoutObserver)
    }()
    
    lazy var moveUseCase: MoveSymbolUseCaseProtocol = {
        let useCase = MoveSymbolUseCase(
            symbol: self.symbol,
            diagramViewConroller: self.diagramViewController)
        useCase.onError = { [unowned self] in self.onError?($0) }
        return useCase
    }()
    
    lazy var deleteUseCase: DeleteSymbolUseCaseProtocol = {
        let useCase = DeleteSymbolUseCase(
            symbol: self.symbol,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onDeleted = { [unowned self] in self.onDeleted?($0) }
        useCase.onError = { [unowned self] in self.onError?($0) }
        return useCase
    }()
    
    lazy var editTextUseCase: EditSymbolTextUseCaseProtocol = {
        let useCase = EditSymbolTextUseCase(
            symbol: self.symbol,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onError = { [unowned self] in self.onError?($0) }
        return useCase
    }()
    
    lazy var resizeUseCase: ResizeSymbolUseCaseProtocol = {
        let useCase = ResizeSymbolUseCase(
            symbol: self.symbol,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onError = { [unowned self] in self.onError?($0) }
        return useCase
    }()
    
    lazy var editProperties: EditSymbolPropertiesUseCaseProtocol = {
        let useCase = EditSymbolPropertiesUseCase(
            symbol: self.symbol,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onError = { [unowned self] in self.onError?($0) }
        return useCase
    }()
    
    lazy var buildTopLinkUseCase: BuildLinkUseCaseProtocol = {
        let useCase = BuildLinkUseCase(
            anchor: self.symbol.topAnchor,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onError = { [unowned self] in self.onError?($0) }
        useCase.onEnded = { [unowned self] in self.onAdded?($0, $1) }
        return useCase
    }()
    
    lazy var buildRightLinkUseCase: BuildLinkUseCaseProtocol = {
        let useCase = BuildLinkUseCase(
            anchor: self.symbol.rightAnchor,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onError = { [unowned self] in self.onError?($0) }
        useCase.onEnded = { [unowned self] in self.onAdded?($0, $1) }
        return useCase
    }()
    
    lazy var buildBottomLinkUseCase: BuildLinkUseCaseProtocol = {
        let useCase = BuildLinkUseCase(
            anchor: self.symbol.bottomAnchor,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onError = { [unowned self] in self.onError?($0) }
        useCase.onEnded = { [unowned self] in self.onAdded?($0, $1) }
        return useCase
    }()
    
    lazy var buildLeftLinkUseCase: BuildLinkUseCaseProtocol = {
        let useCase = BuildLinkUseCase(
            anchor: self.symbol.leftAnchor,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onError = { [unowned self] in self.onError?($0) }
        useCase.onEnded = { [unowned self] in self.onAdded?($0, $1) }
        return useCase
    }()
    
    lazy var buttonsLayoutManager: SymbolButtonsLayoutManagerProtocol = {
        let layoutManager = SymbolUseCaseGroupLayoutManager(
            symbol: self.symbol,
            diagramViewController: self.diagramViewController)
        return layoutManager
    }()
}
