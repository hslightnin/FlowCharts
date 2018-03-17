//
//  LinkLayoutObserver.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 16/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Foundation
import DiagramView

class LinkLayoutObserver: LinkLayoutObserverProtocol {
    
    private let link: FlowChartLink
    private let diagramViewController: DiagramViewController
    private let linkPresenter: LinkPresenter
    
    private var diagramZoomObserver: NSObjectProtocol?
    private var linkLayoutObserver: NSObjectProtocol?
    
    var onLayoutChanged: (() -> Void)?
    
    init(link: FlowChartLink, diagramViewController: DiagramViewController) {
        self.link = link
        self.diagramViewController = diagramViewController
        self.linkPresenter = diagramViewController.presenter(for: link.dataSource)!
    }
    
    func beginObservingLayout() {
        
        diagramZoomObserver = NotificationCenter.default.addObserver(
            forName: .diagramViewControllerDidZoom,
            object: diagramViewController,
            queue: nil,
            using: { [unowned self] _ in self.onLayoutChanged?() })
        
        linkLayoutObserver = NotificationCenter.default.addObserver(
            forName: .linkPresenterDidLayout,
            object: linkPresenter,
            queue: nil,
            using: { [unowned self] _ in self.onLayoutChanged?() })
    }
    
    func endObservingLayout() {
        NotificationCenter.default.removeObserver(diagramZoomObserver!)
        NotificationCenter.default.removeObserver(linkLayoutObserver!)
    }
}
