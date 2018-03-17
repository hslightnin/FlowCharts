//
//  SymbolMissionProtocol.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 14/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit

protocol SymbolMissionProtocol: class {
    var symbol: FlowChartSymbol { get }
    var onAdded: ((FlowChartLink, FlowChartSymbol?) -> Void)? { get set }
    var onDeleted: ((Transition) -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    var presenter: ActivatablePresenter { get }
}
