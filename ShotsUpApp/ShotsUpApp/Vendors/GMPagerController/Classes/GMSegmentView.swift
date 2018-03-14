//
//  GMSegmentView.swift
//  GMSegmentView
//
//  Created by Maxim Lyashenko on 12.10.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit

public enum GMSegmentAction: Int {
    case selectItem    = 0
    case longTapItem   = 1
    case secondTapItem = 2
}


public class GMSegmentView: UIControl {
    
    open var segmentAppearance: GMSegmentAppearance?
    internal var sendAction: ((_ segment: GMSegment, _ actionType: GMSegmentAction)->())?
    
    
    open var numberOfSegments: Int {
        get {
            return segments.count
        }
    }
    
    open var selectedSegmentIndex: Int {
        get {
            if let segment = self.selectedSegment {
                return segment.index
            }
            else {
                return UISegmentedControlNoSegment
            }
        }
        set(newIndex) {
            self.deselectSegment()
            if newIndex >= 0 && newIndex < self.segments.count {
                let currentSelectedSegment = self.segments[newIndex]
                self.selectSegment(currentSelectedSegment)
            }
        }
    }
    
    private var segments: [GMSegment] = []
    private var selectedSegment: GMSegment?
    
    // INITIALISER
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.masksToBounds = true
        self.segmentAppearance = GMSegmentAppearance()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = true
        self.segmentAppearance = GMSegmentAppearance()
    }
    
    
    // MARK: Actions
    // MARK: Select/deselect Segment

    private func selectSegment(_ segment: GMSegment) {
        segment.setSelected(true)
        self.selectedSegment = segment
    }
    private func deselectSegment() {
        self.selectedSegment?.setSelected(false)
        self.selectedSegment = nil
    }

    private func manageTap(_ segment: GMSegment, tapType: GMSegmentAction) {
        self.sendAction?(segment, tapType)
    }
    
    
    // MARK: Add Segment
    
    open func addSegment( highlightedImage: UIImage?, normalImage: UIImage?) {
        self.insertSegment( highlightedImage: highlightedImage, normalImage: normalImage, index: self.segments.count)
    }
    
    open func insertSegment(highlightedImage: UIImage?, normalImage: UIImage?, index: Int) {
        
        let segment = GMSegment(appearance: self.segmentAppearance)
        
        segment.highlightedImage = highlightedImage
        segment.normalImage = normalImage
        segment.index = index
        
        segment.didSelectSegment = { [weak self] segment in
            guard let aSelf = self else { return }
            if aSelf.selectedSegment != segment {
                aSelf.deselectSegment()
                aSelf.selectSegment(segment)
            }
        }
        
        segment.didTapSegment = { [weak self] segment, tapType in
            guard let aSelf = self else { return }
            if aSelf.selectedSegment == segment {
                self?.manageTap(segment, tapType: tapType)
            }
        }
        
        segment.setupUIElements()
        
        self.segments.insert(segment, at: index)
        
        self.addSubview(segment)
        self.layoutSubviews()
    }
    
    
    // MARK: Remove Segment
    
    open func removeAllSegments() {
        
        for (_, segment) in self.segments.enumerated() {
            segment.removeFromSuperview()
        }
        
        self.segments.removeAll()
        self.updateSegmentsLayout()
        self.selectedSegmentIndex = UISegmentedControlNoSegment
    }
    
    
    // MARK: UI
    // MARK: Update layout
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.updateSegmentsLayout()
    }
    
    private func updateSegmentsLayout() {
        
        guard self.segments.count > 0 else {
            return
        }
        
        if self.segments.count > 1 {
            let segmentWidth = ceil((self.frame.size.width) / CGFloat(self.segments.count))
            
            var originX: CGFloat = 0.0
            for segment in self.segments {
                segment.frame = CGRect(x: originX, y: 0.0, width: segmentWidth, height: self.frame.size.height)
                originX += segmentWidth
            }
        } else {
            self.segments[0].frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        }
        
        self.setNeedsDisplay()
    }
}

