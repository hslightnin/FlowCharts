//
//  FlowChartManagedObject.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 15/02/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import CoreData

class FlowChartManagedObject: NSManagedObject {
    var flowChartManagedObjectContext: FlowChartManagedObjectContext {
        guard let flowChartManagedObjectContext = managedObjectContext as? FlowChartManagedObjectContext else {
            fatalError("FlowChartManagedObject must be used in FlowChartManagedObjectContext")
        }
        return flowChartManagedObjectContext
    }
}
