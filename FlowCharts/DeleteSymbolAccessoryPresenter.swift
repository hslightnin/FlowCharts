//
//  SymbolDeleteAccessoryPresenter.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 15/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import DiagramView

protocol SymbolDeleteAccessoryPresenterInteractionsDelegate: class {
    func deleteSymbolAccessoryPresenterDidDeleteSymbol(_ presenter: SymbolDeleteAccessoryPresenter)
}

class SymbolDeleteAccessoryPresenter: AccessoryPresenter, ButtonAccessoryLayoutDelegate, DeleteAccessoryInteractionsDelegate {
    
    private let symbol: FlowChartSymbol
    private let diagramViewController: DiagramViewController
    private unowned let buttonsLayoutDelegate: SymbolButtonsLayoutDelegate
    weak var interactionsDelegate: SymbolDeleteAccessoryPresenterInteractionsDelegate?
    
    init(symbol: FlowChartSymbol,
         diagramViewController: DiagramViewController,
         buttonsLayoutDelegate: SymbolButtonsLayoutDelegate) {
        
        self.symbol = symbol
        self.diagramViewController = diagramViewController
        self.buttonsLayoutDelegate = buttonsLayoutDelegate
        super.init()
    }
    
    // MARK: - Lifecycle
    
    override func loadAccessory() -> Accessory! {
        let accessory = DeleteAccessory(
            accessoryView: diagramViewController.accessoryView,
            layoutDelegate: self)
        accessory.interactionsDelegate = self
        return accessory
    }
    
    // MARK: - Layout Delegate
    
    func buttonAccessory(_ accessory: ButtonAccessory, locationForButtonInView view: UIView) -> CGPoint {
        let buttonsRect = buttonsLayoutDelegate.symbolButtonsRect(inView: view)
        return CGPoint(x: buttonsRect.minX, y: buttonsRect.minY)
    }
    
    // MARK: - Interactions
    
    func deleteAccessoryDidTriggerDelete(_ accessory: DeleteAccessory) {
        DeleteSymbolInteractor.remove(symbol: symbol)
        interactionsDelegate?.deleteSymbolAccessoryPresenterDidDeleteSymbol(self)
    }
}
