//
//  PinBoardCustomCollectionViewCell.swift
//  ImagesLoader
//
//  Created by Ahmed Shafik on 7/27/19.
//  Copyright © 2019 Ahmed Shafik. All rights reserved.
//

import UIKit

class PinBoardCustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet  var imageView: CustomImageViewLoader!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }
//    var imageUrl: String? {
//        didSet {
//            if let imageUrl = imageUrl {
//                imageView.loadImageWithUrl(urlString: imageUrl)
//            }
//        }
//    }
    fileprivate var imageViewHeightLayoutConstraint: NSLayoutConstraint?
    fileprivate var imageHeight: CGFloat!
    
    override public func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? PinboardLayoutAttributes {
            imageHeight = attributes.imageHeight
            if let imageViewHeightLayoutConstraint = self.imageViewHeightLayoutConstraint {
                imageViewHeightLayoutConstraint.constant = attributes.imageHeight
            }
        }
    }

}
