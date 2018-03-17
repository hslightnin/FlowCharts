//
//  LinkMissionContextProtocol.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 10/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit

protocol LinkMissionPresenterProtocol: class {
    var link: FlowChartLink { get }
    var onDeleted: ((Transition) -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
}
