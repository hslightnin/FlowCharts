//
//  DebugSymbolMission.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 15/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit


class DebugMoveSymbolInteractor: MoveSymbolInteractor {
    override func save(withIn transition: Transition) throws {
        if UserDefaults.standard.simulateMoveSymbolErrors {
            throw DebugError()
        } else {
            try super.save(withIn: transition)
        }
    }
}

class DebugDeleteSymbolInteractor: DeleteSymbolInteractor {
    override func save(withIn transition: Transition) throws {
        if UserDefaults.standard.simulateDeleteSymbolErrors {
            throw DebugError()
        } else {
            try super.save(withIn: transition)
        }
    }
}

class DebugEditSymbolTextInteractor: EditSymbolTextInteractor {
    override func save(withIn transition: Transition) throws {
        if UserDefaults.standard.simulateEditSymbolTextErrors {
            throw DebugError()
        } else {
            try super.save(withIn: transition)
        }
    }
}

class DebugResizeSymbolInteractor: ResizeSymbolInteractor {
    override func save(withIn transition: Transition) throws {
        if UserDefaults.standard.simulateResizeSymbolErrors {
            throw DebugError()
        } else {
            try super.save(withIn: transition)
        }
    }
}

class DebugEditSymbolPropertiesInteractor: EditSymbolPropertiesInteractor {
    override func save(withIn transition: Transition) throws {
        if UserDefaults.standard.simulateEditSymbolPropertiesErrors {
            throw DebugError()
        } else {
            try super.save(withIn: transition)
        }
    }
}

class DebugBuildLinkInteractor: BuildLinkInteractor {
    override func save(withIn transition: Transition) throws {
        if UserDefaults.standard.simulateBuildLinkErrorsEnabled {
            throw DebugError()
        } else {
            try super.save(withIn: transition)
        }
    }
}

class DebugMoveSymbolUseCase: MoveSymbolUseCase {
    override class func loadInteractor(symbol: FlowChartSymbol) -> MoveSymbolInteractor {
        return DebugMoveSymbolInteractor(symbol: symbol)
    }
}

class DebugDeleteSymbolUseCase: DeleteSymbolUseCase {
    override class func loadInteractor(symbol: FlowChartSymbol) -> DeleteSymbolInteractor {
        return DebugDeleteSymbolInteractor(symbol: symbol)
    }
}

class DebugEditSymbolTextUseCase: EditSymbolTextUseCase {
    override class func loadInteractor(symbol: FlowChartSymbol) -> DebugEditSymbolTextInteractor {
        return DebugEditSymbolTextInteractor(symbol: symbol)
    }
}

class DebugResizeSymbolUseCase: ResizeSymbolUseCase {
    override class func loadInteractor(symbol: FlowChartSymbol) -> DebugResizeSymbolInteractor {
        return DebugResizeSymbolInteractor(symbol: symbol)
    }
}

class DebugEditSymbolPropertiesUseCase: EditSymbolPropertiesUseCase {
    override class func loadInteractor(symbol: FlowChartSymbol) -> EditSymbolPropertiesInteractor {
        return DebugEditSymbolPropertiesInteractor(symbol: symbol)
    }
}

class DebugBuildLinkUseCase: BuildLinkUseCase {
    override class func loadInteractor(anchor: FlowChartSymbolAnchor) -> BuildLinkInteractor {
        return DebugBuildLinkInteractor(anchor: anchor)
    }
}

class DebugSymbolMission: SymbolMission {
    
    override lazy var moveUseCase: MoveSymbolUseCaseProtocol = {
        let useCase = DebugMoveSymbolUseCase(
            symbol: self.symbol,
            diagramViewConroller: self.diagramViewController)
        useCase.onError = { [unowned self] in self.onError?($0) }
        return useCase
    }()
    
    override lazy var deleteUseCase: DeleteSymbolUseCaseProtocol = {
        let useCase = DebugDeleteSymbolUseCase(
            symbol: self.symbol,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onDeleted = { [unowned self] in self.onDeleted?($0) }
        useCase.onError = { [unowned self] in self.onError?($0) }
        return useCase
    }()
    
    override lazy var editTextUseCase: EditSymbolTextUseCaseProtocol = {
        let useCase = DebugEditSymbolTextUseCase(
            symbol: self.symbol,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onError = { [unowned self] in self.onError?($0) }
        return useCase
    }()
    
    override lazy var resizeUseCase: ResizeSymbolUseCaseProtocol = {
        let useCase = DebugResizeSymbolUseCase(
            symbol: self.symbol,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onError = { [unowned self] in self.onError?($0) }
        return useCase
    }()
    
    override lazy var editProperties: EditSymbolPropertiesUseCaseProtocol = {
        let useCase = DebugEditSymbolPropertiesUseCase(
            symbol: self.symbol,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onError = { [unowned self] in self.onError?($0) }
        return useCase
    }()
    
    override lazy var buildTopLinkUseCase: BuildLinkUseCaseProtocol = {
        let useCase = DebugBuildLinkUseCase(
            anchor: self.symbol.topAnchor,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onError = { [unowned self] in self.onError?($0) }
        useCase.onEnded = { [unowned self] in self.onAdded?($0, $1) }
        return useCase
    }()
    
    override lazy var buildRightLinkUseCase: BuildLinkUseCaseProtocol = {
        let useCase = DebugBuildLinkUseCase(
            anchor: self.symbol.rightAnchor,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onError = { [unowned self] in self.onError?($0) }
        useCase.onEnded = { [unowned self] in self.onAdded?($0, $1) }
        return useCase
    }()
    
    override lazy var buildBottomLinkUseCase: BuildLinkUseCaseProtocol = {
        let useCase = DebugBuildLinkUseCase(
            anchor: self.symbol.bottomAnchor,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onError = { [unowned self] in self.onError?($0) }
        useCase.onEnded = { [unowned self] in self.onAdded?($0, $1) }
        return useCase
    }()
    
    override lazy var buildLeftLinkUseCase: BuildLinkUseCaseProtocol = {
        let useCase = DebugBuildLinkUseCase(
            anchor: self.symbol.leftAnchor,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onError = { [unowned self] in self.onError?($0) }
        useCase.onEnded = { [unowned self] in self.onAdded?($0, $1) }
        return useCase
    }()
}
