//
//  LinkMissionInteractor.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 16/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit

class LinkMissionInteractor: LinkMissionInteractorProtocol {
    
    private let link: FlowChartLink
    
    init(link: FlowChartLink) {
        self.link = link
    }
    
    func focusLink(withIn transition: Transition) {
        link.dataSource.focus(withIn: transition)
    }
    
    func unfocusLink(withIn transition: Transition) {
        link.dataSource.unfocus(withIn: transition)
    }
}

