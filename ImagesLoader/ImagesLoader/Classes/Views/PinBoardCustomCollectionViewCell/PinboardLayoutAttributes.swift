//
//  PinboardLayoutAttributes.swift
//  ImagesLoader
//
//  Created by Ahmed Shafik on 7/27/19.
//  Copyright © 2019 Ahmed Shafik. All rights reserved.
//

import UIKit

class PinboardLayoutAttributes: UICollectionViewLayoutAttributes {
    public var imageHeight: CGFloat = 0
    
    override public func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! PinboardLayoutAttributes
        copy.imageHeight = imageHeight
        return copy
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? PinboardLayoutAttributes {
            if attributes.imageHeight == imageHeight {
                return super.isEqual(object)
            }
        }
        return false
    }

}
