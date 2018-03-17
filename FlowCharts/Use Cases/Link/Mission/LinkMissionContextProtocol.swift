//
//  LinkMissionContextProtocol.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 10/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit

protocol DeleteLinkUseCaseProtocol: class {
    var presenter: ActivatablePresenter { get }
    var onDeleted: ((Transition) -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    func layout()
}

protocol EditLinkAnchorUseCaseProtocol: class {
    var presenter: ActivatablePresenter { get }
    var onError: ((Error) -> Void)? { get set }
    func layout()
}

protocol EditLinkTextUseCaseProtocol: class {
    var presenter: ActivatablePresenter { get }
    var onError: ((Error) -> Void)? { get set }
    func layout()
}

protocol EditLinkPropertiesUseCaseProtocol: class {
    var presenter: ActivatablePresenter { get }
    var onError: ((Error) -> Void)? { get set }
    func layout()
}

protocol LinkMissionContextProtocol: class {
    
    var link: FlowChartLink { get }
    var presenter: ActivatableGroupPresenter { get }
    
    var onDeleted: ((Transition) -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
}
