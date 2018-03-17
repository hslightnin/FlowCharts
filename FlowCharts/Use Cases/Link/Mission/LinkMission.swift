//
//  LinkMission.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 16/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import DiagramView
import PresenterKit

protocol DeleteLinkUseCaseProtocol: class {
    var presenter: ActivatablePresenter & UseCasePresenterProtocol { get }
    var onDeleted: ((Transition) -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
}

protocol EditLinkAnchorUseCaseProtocol: class {
    var presenter: ActivatablePresenter & UseCasePresenterProtocol { get }
    var onError: ((Error) -> Void)? { get set }
}

protocol EditLinkTextUseCaseProtocol: class {
    var presenter: ActivatablePresenter & UseCasePresenterProtocol { get }
    var onError: ((Error) -> Void)? { get set }
}

protocol EditLinkPropertiesUseCaseProtocol: class {
    var presenter: ActivatablePresenter & UseCasePresenterProtocol { get }
    var onError: ((Error) -> Void)? { get set }
}

protocol LinkButtonsLayoutManagerProtocol: class {
    func deleteButtonLocation(in view: UIView) -> CGPoint
    func editTextButtonLocation(in view: UIView) -> CGPoint
    func editPropertiesButtonLocation(in view: UIView) -> CGPoint
    func originButtonLocation(in view: UIView) -> CGPoint
    func endingButtonLocation(in view: UIView) -> CGPoint
}

class LinkMission: LinkMissionProtocol {
    
    let link: FlowChartLink
    let diagramViewController: DiagramViewController
    
    var onDeleted: ((Transition) -> Void)?
    var onError: ((Error) -> Void)?
    
    init(link: FlowChartLink, diagramViewController: DiagramViewController) {
        self.link = link
        self.diagramViewController = diagramViewController
    }
    
    lazy var presenter: ActivatablePresenter = {
        
        let presenters: [ActivatablePresenter & UseCasePresenterProtocol] = [
            self.deleteUseCase.presenter,
            self.editTextUseCase.presenter,
            self.editPropertiesUseCase.presenter,
            self.editOriginUseCase.presenter,
            self.editEndingUseCase.presenter
        ]
        
        let layoutObserver = LinkLayoutObserver(
            link: self.link,
            diagramViewController: self.diagramViewController)
        
        let interactor = LinkMissionInteractor(link: self.link)
        
        return LinkMissionPresenter(
            presenters: presenters,
            interactor: interactor,
            layoutObserver: layoutObserver)
    }()
    
    lazy var deleteUseCase: DeleteLinkUseCase = {
        let useCase = DeleteLinkUseCase(
            link: self.link,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onDeleted = { [unowned self] in self.onDeleted?($0) }
        useCase.onError = { [unowned self] in self.onError?($0) }
        return useCase
    }()
    
    lazy var editTextUseCase: EditLinkTextUseCase = {
        let useCase = EditLinkTextUseCase(
            link: self.link,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onError = { [unowned self] in self.onError?($0) }
        return useCase
    }()
    
    lazy var editPropertiesUseCase: EditLinkPropertiesUseCase = {
        let useCase = EditLinkPropertiesUseCase(
            link: self.link,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onError = { [unowned self] in self.onError?($0) }
        return useCase
    }()
    
    lazy var editOriginUseCase: EditLinkAnchorUseCase = {
        let useCase = EditLinkAnchorUseCase(
            anchor: self.link.origin,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onError = { [unowned self] in self.onError?($0) }
        return useCase
    }()
    
    lazy var editEndingUseCase: EditLinkAnchorUseCase = {
        let useCase = EditLinkAnchorUseCase(
            anchor: self.link.ending,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onError = { [unowned self] in self.onError?($0) }
        return useCase
    }()
    
    lazy var buttonsLayoutManager: LinkButtonsLayoutManagerProtocol = {
        let layoutManager = LinkButtonsLayoutManager(
            link: self.link,
            diagramViewController: self.diagramViewController)
        return layoutManager
    }()
}
