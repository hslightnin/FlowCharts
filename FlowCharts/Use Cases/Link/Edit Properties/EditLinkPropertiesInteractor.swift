//
//  EditLinkPresetsInteractor.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 04/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import DiagramGeometry

class EditLinkPropertiesInteractor: Interactor, EditLinkPropertiesInteractorProtocol {
    
    let link: FlowChartLink
    
    init(link: FlowChartLink) {
        self.link = link
        super.init(managedObjectContext: link.flowChartManagedObjectContext)
    }
    
    var linkTextRect: Rect? {
        return link.arrow.textRect
    }
    
    var linkCenter: Point {
        return link.arrow.center
    }
    
    var lineTypePreset: LineTypePreset {
        get { return link.lineTypePreset }
        set { link.lineTypePreset = newValue }
    }
    
    var lineDashPatternPreset: LineDashPatternPreset {
        get { return link.lineDashPatternPreset }
        set { link.lineDashPatternPreset = newValue }
    }
}
