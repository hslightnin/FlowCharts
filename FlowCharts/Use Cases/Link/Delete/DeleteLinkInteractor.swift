//
//  DeleteLinkInteractor.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 03/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

class DeleteLinkInteractor: Interactor, DeleteLinkInteractorProtocol {
    
    let link: FlowChartLink
    
    init(link: FlowChartLink) {
        self.link = link
        super.init(managedObjectContext: link.flowChartManagedObjectContext)
    }
    
    func deleteLink() {
        managedObjectContext.delete(link)
    }
}
