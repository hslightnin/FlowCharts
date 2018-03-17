//
//  LineTypesViewController.swift
//  FlowCharts
//
//  Created by alex on 08/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry

protocol LinePresetsViewControllerDelegate: class {
    func linePresetsViewController(
        _ controller: LinePresetsViewController,
        didSelectLineTypePreset lineTypePreset: LineTypePreset,
        lineDashPatternPreset: LineDashPatternPreset)
}

class LinePresetsViewController: UICollectionViewController {

    weak var delegate: LinePresetsViewControllerDelegate?
    
    var lineTypePresets = [LineTypePreset]() {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    var selectedLineTypePreset: LineTypePreset? {
        didSet {
            updateSelection()
        }
    }
    
    var lineDashPatternPresets = [LineDashPatternPreset]() {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    var selectedLineDashPatternPreset: LineDashPatternPreset? {
        didSet {
            updateSelection()
        }
    }
    
    private func lineTypePreset(at indexPath: IndexPath) -> LineTypePreset {
        let typePresetIndex = indexPath.row % lineTypePresets.count
        return lineTypePresets[typePresetIndex]
    }
    
    private func lineDashPatternPreset(at indexPath: IndexPath) -> LineDashPatternPreset {
        let dashPatternPresetIndex = indexPath.row / lineTypePresets.count
        return lineDashPatternPresets[dashPatternPresetIndex]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateSelection()
    }
    
    private func updateSelection() {
        
        let currentSelectedIndexPath = collectionView!.indexPathsForSelectedItems?.first
        
        var newSelectedIndexPath: IndexPath? = nil
        if selectedLineTypePreset != nil && selectedLineDashPatternPreset != nil {
            let selectedTypeIndex = lineTypePresets.index(where: { $0 === selectedLineTypePreset! })!
            let selectedDashPatternIndex = lineDashPatternPresets.index(where: { $0 === selectedLineDashPatternPreset! })!
            let selectedRow = selectedTypeIndex + selectedDashPatternIndex * lineTypePresets.count
            newSelectedIndexPath = IndexPath(row: selectedRow, section: 0)
        }
        
        if currentSelectedIndexPath != newSelectedIndexPath {
            
            if currentSelectedIndexPath != nil {
                collectionView!.deselectItem(at: currentSelectedIndexPath!, animated: true)
            }
            
            if newSelectedIndexPath != nil {
                collectionView?.selectItem(at: newSelectedIndexPath, animated: true, scrollPosition: .top)
            }
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lineTypePresets.count * lineDashPatternPresets.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LinePresetCollectionViewCell
        cell.lineType = lineTypePreset(at: indexPath).thumbnailLineType
        cell.lineDashPattern = lineDashPatternPreset(at: indexPath).thumbnailPattern
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let typePreset = lineTypePreset(at: indexPath)
        let dashPatternPreset = lineDashPatternPreset(at: indexPath)
        
        if typePreset !== selectedLineTypePreset || dashPatternPreset !== selectedLineDashPatternPreset {
            selectedLineTypePreset = typePreset
            selectedLineDashPatternPreset = dashPatternPreset
            delegate?.linePresetsViewController(self,
                didSelectLineTypePreset: typePreset,
                lineDashPatternPreset: dashPatternPreset)
        }
    }
}
