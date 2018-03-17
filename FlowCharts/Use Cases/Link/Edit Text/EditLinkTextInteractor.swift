//
//  EditLinkTextInteractor.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 03/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry

class EditLinkTextInteractor: ContinuousInteractor, EditLinkTextInteractorProtocol {
    
    private let link: FlowChartLink
    
    init(link: FlowChartLink) {
        self.link = link
        super.init(managedObjectContext: link.flowChartManagedObjectContext)
    }
    
    var text: String? {
        get { return link.text }
        set { link.text = newValue }
    }
    
    var font: UIFont {
        return link.font
    }
    
    var textInsets: Vector {
        return Vector(2, 6)
    }
    
    var maxTextWidth: Double {
        return link.maxTextWidth
    }
    
    var linkCenter: Point {
        return link.arrow.center
    }
}
