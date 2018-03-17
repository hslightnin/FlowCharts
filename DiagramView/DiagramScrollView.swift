//
//  DiagramScrollView.swift
//  FlowCharts
//
//  Created by alex on 11/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit

class DiagramScrollView: UIScrollView {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.centralize()
    }
    
    override func scrollRectToVisible(_ rect: CGRect, animated: Bool) {
        // Doing nothing
        // When we add UITextView to UIScrollView's content view this method is called
        // and contentOffset is changed.
        // TODO: Research why is this hapenning
    }
    
    func centralize() {
        if let viewForZoom = self.delegate?.viewForZooming?(in: self) {
            
            var boundsSize = self.bounds.size
            boundsSize.height -= self.contentInset.top
            
            var frameToCenter = viewForZoom.frame
            
            if (frameToCenter.size.width < boundsSize.width) {
                frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
            } else {
                frameToCenter.origin.x = 0
            }
            
            if (frameToCenter.size.height < boundsSize.height) {
                frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
            } else {
                frameToCenter.origin.y = 0
            }
            
            viewForZoom.frame = frameToCenter
        }
    }
}
