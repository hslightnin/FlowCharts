//
//  LinkMissionProtocol.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 16/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit

protocol LinkMissionProtocol: class {
    var link: FlowChartLink { get }
    var onDeleted: ((Transition) -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    var presenter: ActivatablePresenter{ get }
}
