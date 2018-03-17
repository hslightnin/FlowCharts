//
//  DebugLinkMission.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 16/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit

class DebugDeleteLinkInteractor: DeleteLinkInteractor {
    override func save(withIn transition: Transition) throws {
        if UserDefaults.standard.simulateDeleteLinkErrors {
            throw DebugError()
        } else {
            try super.save(withIn: transition)
        }
    }
}

class DebugEditLinkTextInteractor: EditLinkTextInteractor {
    override func save(withIn transition: Transition) throws {
        if UserDefaults.standard.simulateEditLinkTextErrors {
            throw DebugError()
        } else {
            try super.save(withIn: transition)
        }
    }
}

class DebugEditLinkPropertiesInteractor: EditLinkPropertiesInteractor {
    override func save(withIn transition: Transition) throws {
        if UserDefaults.standard.simulateEditLinkPropertiesErrors {
            throw DebugError()
        } else {
            try super.save(withIn: transition)
        }
    }
}

class DebugMoveLinkAnchorInteractor: MoveLinkAnchorInteractor {
    override func save(withIn transition: Transition) throws {
        if UserDefaults.standard.simulateMoveLinkAnchorErrors {
            throw DebugError()
        } else {
            try super.save(withIn: transition)
        }
    }
}

class DebugEditLinkAnchorPropertiesInteractor: EditLinkAnchorPropertiesInteractor {
    override func save(withIn transition: Transition) throws {
        if UserDefaults.standard.simulateEditLinkAnchorPropertiesErrors {
            throw DebugError()
        } else {
            try super.save(withIn: transition)
        }
    }
}

class DebugDeleteLinkUseCase: DeleteLinkUseCase {
    override class func loadInteractor(link: FlowChartLink) -> DeleteLinkInteractor {
        return DebugDeleteLinkInteractor(link: link)
    }
}

class DebugEditLinkTextUseCase: EditLinkTextUseCase {
    override class func loadInteractor(link: FlowChartLink) -> DebugEditLinkTextInteractor {
        return DebugEditLinkTextInteractor(link: link)
    }
}

class DebugEditLinkPropertiesUseCase: EditLinkPropertiesUseCase {
    override class func loadInteractor(link: FlowChartLink) -> EditLinkPropertiesInteractor {
        return DebugEditLinkPropertiesInteractor(link: link)
    }
}

class DebugEditLinkAnchorUseCase: EditLinkAnchorUseCase {
    
    override class func loadMoveInteractor(anchor: FlowChartLinkAnchor) -> MoveLinkAnchorInteractor {
        return DebugMoveLinkAnchorInteractor(anchor: anchor)
    }
    
    override class func loadEditPropertiesInteractor(anchor: FlowChartLinkAnchor) -> EditLinkAnchorPropertiesInteractor {
        return DebugEditLinkAnchorPropertiesInteractor(anchor: anchor)
    }
}

class DebugLinkMission: LinkMission {
    
    override lazy var deleteUseCase: DeleteLinkUseCase = {
        let useCase = DebugDeleteLinkUseCase(
            link: self.link,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onDeleted = { [unowned self] in self.onDeleted?($0) }
        useCase.onError = { [unowned self] in self.onError?($0) }
        return useCase
    }()
    
    override lazy var editTextUseCase: EditLinkTextUseCase = {
        let useCase = DebugEditLinkTextUseCase(
            link: self.link,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onError = { [unowned self] in self.onError?($0) }
        return useCase
    }()
    
    override lazy var editPropertiesUseCase: EditLinkPropertiesUseCase = {
        let useCase = DebugEditLinkPropertiesUseCase(
            link: self.link,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onError = { [unowned self] in self.onError?($0) }
        return useCase
    }()
    
    override lazy var editOriginUseCase: EditLinkAnchorUseCase = {
        let useCase = DebugEditLinkAnchorUseCase(
            anchor: self.link.origin,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onError = { [unowned self] in self.onError?($0) }
        return useCase
    }()
    
    override lazy var editEndingUseCase: EditLinkAnchorUseCase = {
        let useCase = DebugEditLinkAnchorUseCase(
            anchor: self.link.ending,
            diagramViewController: self.diagramViewController,
            buttonsLayoutManager: self.buttonsLayoutManager)
        useCase.onError = { [unowned self] in self.onError?($0) }
        return useCase
    }()
}
