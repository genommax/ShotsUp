//
//  GMSegment.swift
//  GMSegmentView
//
//  Created by Maxim Lyashenko on 12.10.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit


internal class GMSegment: UIView {
    
    // UI components
    private var imageView: UIImageView = UIImageView()
    
    
    // Image
    internal var highlightedImage: UIImage?
    internal var normalImage: UIImage?
    
    // Appearance
    internal var appearance: GMSegmentAppearance?
    
    internal var didSelectSegment: ((_ segment: GMSegment)->())?
    internal var didTapSegment: ((_ segment: GMSegment, _ tapType: GMSegmentAction)->())?
    
    internal(set) var index: Int = 0
    private(set) var isSelected: Bool = false
    
    
    // Init
    internal init(appearance: GMSegmentAppearance?) {
        
        self.appearance = appearance
        
        super.init(frame: CGRect.zero)
        self.addUIElementsToView()
        
        self.setupRecognizer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: CGRect) {
        fatalError("init(frame:) won't work properly. Use init(appearance:) instead")
    }
    
    private func addUIElementsToView() {        
        self.imageView.contentMode = UIViewContentMode.scaleAspectFit
        self.addSubview(self.imageView)
    }
    
    internal func setupUIElements() {
        DispatchQueue.main.async(execute: {
            if let appearance = self.appearance {
                self.backgroundColor = appearance.segmentOffSelectionColour
            }
            self.imageView.image = self.normalImage
        })
    }
    
    
    // MARK: Update label and imageView frame
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        
        
        var verticalMargin: CGFloat = 0.0
         var bottomMargin: CGFloat = 0.0
        if let appearance = self.appearance {
            verticalMargin = appearance.contentVerticalMargin
            bottomMargin = appearance.contentBottomMargin
        }
                
 
        var imageViewFrame = CGRect(x: 0.0, y: verticalMargin - bottomMargin, width: 0.0, height: self.frame.size.height - verticalMargin*2)
        if self.highlightedImage != nil || self.normalImage != nil {
            imageViewFrame.size.width = self.frame.size.height - verticalMargin*2
        }
        
        imageViewFrame.origin.x = max((self.frame.size.width - imageViewFrame.size.width) / 2.0, 0.0)
        
        self.imageView.frame = imageViewFrame
        
    }
    
    
    // MARK: Selections
    
    internal func setupRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        self.addGestureRecognizer(tapRecognizer)
        
        let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap(recognizer:)))
        longTapRecognizer.minimumPressDuration = 0.75
        self.addGestureRecognizer(longTapRecognizer)
    }
    
    //function called when tap detected
    @objc func handleTap(recognizer: UITapGestureRecognizer){
        
        if self.isSelected == false {
            self.didSelectSegment?(self)
            self.didTapSegment?(self, .selectItem)
        } else {
            if recognizer.state == UIGestureRecognizerState.ended {
                self.didTapSegment?(self, .secondTapItem)
            }
        }
    }
    
    @objc func handleLongTap(recognizer: UITapGestureRecognizer){
        if self.isSelected == false{
            self.didSelectSegment?(self)
            self.didTapSegment?(self, .longTapItem)
        } else {
            if recognizer.state == UIGestureRecognizerState.began {
                self.didTapSegment?(self, .longTapItem)
            }
        }
    }
    
    internal func setSelected(_ selected: Bool) {
        self.isSelected = selected
        if selected == true {
            DispatchQueue.main.async(execute: {
                self.backgroundColor = self.appearance?.segmentOnSelectionColour
            })
            
            UIView.transition(with: self.imageView,
                              duration:0.25,
                              options: .transitionCrossDissolve,
                              animations: {
                                DispatchQueue.main.async(execute: {
                                    self.imageView.image = self.highlightedImage
                                })
            },
                              completion: nil)
            
        } else {
            DispatchQueue.main.async(execute: {
                self.backgroundColor = self.appearance?.segmentOffSelectionColour
                self.imageView.image = self.normalImage
            })
        }
    }
}
