//
//  DiagramPresenter.swift
//  FlowCharts
//
//  Created by alex on 11/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import PresenterKit
import DiagramGeometry

public class DiagramPresenter: FreePresenter, DiagramDataSourceDelegate {
    
    let diagram: DiagramDataSource
    private let presentingView: UIView
    unowned let coordinatesConverter: DiagramCoordinatesConverter
    
    private(set) var symbolPresenters = [SymbolPresenter]()
    private(set) var linkPresenters = [LinkPresenter]()
    
    init(diagram: DiagramDataSource, presentingView: UIView, coordinatesConverter: DiagramCoordinatesConverter) {
        self.diagram = diagram
        self.presentingView = presentingView
        self.coordinatesConverter = coordinatesConverter
    }
    
    // MARK: - Properties
    
    var contentScaleFactor: CGFloat = 1.0 {
        didSet {
            symbolPresenters.forEach { $0.contentScaleFactor = contentScaleFactor }
            linkPresenters.forEach { $0.contentScaleFactor = contentScaleFactor }
        }
    }
    
    // MARK: - Presented items
    
    public lazy var diagramView: UIView = {
        let diagramView = UIView()
        diagramView.accessibilityIdentifier = "diagram_content_view"
        diagramView.backgroundColor = .white
        diagramView.clipsToBounds = true
        return diagramView
    }()
    
    public lazy var backgroundView: UIView = {
        let backgroundView = PassThroughView()
        backgroundView.accessibilityIdentifier = "digram_background_view"
        backgroundView.backgroundColor = .clear
        return backgroundView
    }()
    
    public lazy var linksView: UIView = {
        let linksView = PassThroughView()
        linksView.accessibilityIdentifier = "digram_links_view"
        linksView.backgroundColor = .clear
        return linksView
    }()
    
    public lazy var symbolsView: UIView = {
        let symbolsView = PassThroughView()
        symbolsView.accessibilityIdentifier = "digram_symbols_view"
        symbolsView.backgroundColor = .clear
        return symbolsView
    }()
    
    public lazy var pointersView: UIView = {
        let pointersView = PassThroughView()
        pointersView.accessibilityIdentifier = "digram_points_view"
        pointersView.backgroundColor = .clear
        return pointersView
    }()
    
    // MARK: - Lifecycle
    
    public override func setUpPresentation(withIn transition: Transition) {
        super.setUpPresentation(withIn: transition)
        
        transition.addBeginning {
            
            self.diagramView.addSubview(self.backgroundView)
            self.diagramView.addSubview(self.linksView)
            self.diagramView.addSubview(self.symbolsView)
            self.diagramView.addSubview(self.pointersView)
            self.presentingView.addSubview(self.diagramView)
            
            self.updateFrame()
            
            for dataSource in self.diagram.symbolDataSources {
                self.present(symbol: dataSource, with: .instant())
            }
            
            for dataSource in self.diagram.linkDataSources {
                self.present(link: dataSource, with: .instant())
            }
            
            self.diagram.delegate = self
        }
    }
    
    public override func setUpDismission(withIn transition: Transition) {
        super.setUpDismission(withIn: transition)
        
        transition.addBeginning {
            
            self.diagram.delegate = nil
            
            for dataSource in self.diagram.symbolDataSources {
                self.dismiss(symbol: dataSource, with: .instant())
            }
            
            for dataSource in self.diagram.linkDataSources {
                self.dismiss(link: dataSource, with: .instant())
            }
            
            self.diagramView.removeFromSuperview()
        }
    }
    
    // MARK: - Diagram data source delegate
    
    public func diagramWillChangeSize(_ diagramDataSource: DiagramDataSource, withIn trasition: Transition) {
        trasition.addBeginning {
            self.updateFrame()
        }
    }
    
    public func diagram(_ dataSource: DiagramDataSource, willAddSymbols symbolDataSources: [SymbolDataSource], withIn transition: Transition) {
        symbolDataSources.forEach { present(symbol: $0, withIn: transition) }
    }
    
    public func diagram(_ dataSource: DiagramDataSource, willRemoveSymbols symbolDataSources: [SymbolDataSource], withIn transition: Transition) {
        symbolDataSources.forEach { dismiss(symbol: $0, withIn: transition) }
    }
    
    public func diagram(_ dataSource: DiagramDataSource, willAddLinks linkDataSources: [LinkDataSource], withIn transition: Transition) {
        linkDataSources.forEach { present(link: $0, withIn: transition) }
    }
    
    public func diagram(_ dataSource: DiagramDataSource, willRemoveLinks linkDataSources: [LinkDataSource], withIn transition: Transition) {
        linkDataSources.forEach { dismiss(link: $0, withIn: transition) }
    }
    
    // MARK: - Presentation
    
    // MARK: Diagram
    
    private func updateFrame() {
        
        let width = diagram.size.width
        let height = diagram.size.height
        let diagramRect = Rect(x: 0, y: 0, width: width, height: height)
        let viewRect = coordinatesConverter.viewRect(for: diagramRect, in: presentingView)
        diagramView.frame = viewRect
        
        pointersView.frame = diagramView.bounds
        symbolsView.frame = diagramView.bounds
        linksView.frame = diagramView.bounds
        backgroundView.frame = diagramView.bounds
    }
    
    // MARK: Symbols
    
    private func present(symbol dataSource: SymbolDataSource, withIn transition: Transition) {
        let symbolPresenter = SymbolPresenter(
            dataSource: dataSource,
            symbolsView: symbolsView,
            coordinatesConverter: coordinatesConverter)
        symbolPresenter.contentScaleFactor = contentScaleFactor
        symbolPresenters.append(symbolPresenter)
        symbolPresenter.prepareForPresentation(withIn: transition)
    }
    
    private func present(symbol dataSource: SymbolDataSource, with transition: Transition) {
        present(symbol: dataSource, withIn: transition)
        transition.perform()
    }
    
    private func dismiss(symbol dataSource: SymbolDataSource, withIn transition: Transition) {
        if let presenterIndex = symbolPresenters.index(where: { $0.dataSource === dataSource }) {
            let symbolPresenter = symbolPresenters.remove(at: presenterIndex)
            symbolPresenter.prepareForDismission(withIn: transition)
        }
    }
    
    private func dismiss(symbol dataSource: SymbolDataSource, with transition: Transition) {
        dismiss(symbol: dataSource, withIn: transition)
        transition.perform()
    }
    
    // MARK: Links
    
    private func present(link dataSource: LinkDataSource, withIn transition: Transition) {
        let linkPresenter = LinkPresenter(
            dataSource: dataSource,
            linksView: linksView,
            pointersView: pointersView,
            coordinatesConverter: coordinatesConverter)
        linkPresenter.contentScaleFactor = contentScaleFactor
        linkPresenters.append(linkPresenter)
        linkPresenter.prepareForPresentation(withIn: transition)
    }
    
    private func present(link dataSource: LinkDataSource, with transition: Transition) {
        present(link: dataSource, withIn: transition)
        transition.perform()
    }
    
    private func dismiss(link dataSource: LinkDataSource, withIn transition: Transition) {
        if let presenterIndex = linkPresenters.index(where: { $0.dataSource === dataSource }) {
            let linkPresenter = linkPresenters.remove(at: presenterIndex)
            linkPresenter.prepareForDismission(withIn: transition)
        }
    }
    
    private func dismiss(link dataSource: LinkDataSource, with transition: Transition) {
        dismiss(link: dataSource, withIn: transition)
        transition.perform()
    }
}
