//
//  FlowChartManagedObjectContext.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 15/02/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import CoreData

class FlowChartManagedObjectContext: NSManagedObjectContext {
    
    let manager: FlowChartManagedObjectContextManager
    
    init(concurrencyType ct: NSManagedObjectContextConcurrencyType, manager: FlowChartManagedObjectContextManager) {
        self.manager = manager
        super.init(concurrencyType: ct)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
