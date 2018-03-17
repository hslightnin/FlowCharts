//
//  EditLinkAnchorInteractor.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 03/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import DiagramGeometry

class EditLinkAnchorPropertiesInteractor: Interactor, EditLinkAnchorPropertiesInteractorProtocol {
    
    private let anchor: FlowChartLinkAnchor
    
    init(anchor: FlowChartLinkAnchor) {
        self.anchor = anchor
        super.init(managedObjectContext: anchor.flowChartManagedObjectContext)
    }
    
    var pointerVector: Vector {
        if anchor.isOrigin {
            return anchor.link.arrow.vector1
        } else {
            return anchor.link.arrow.vector2
        }
    }
    
    var pointerPreset: PointerPreset {
        get { return anchor.pointerPreset }
        set { anchor.pointerPreset = newValue }
    }
    
//    func setPointPreset(_ preset: PointerPreset) {
//        anchor.pointerPreset = preset
//    }
}
