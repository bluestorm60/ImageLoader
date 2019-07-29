//
//  CustomImageViewLoader.swift
//  ImagesLoader
//
//  Created by Ahmed Shafik on 7/27/19.
//  Copyright © 2019 Ahmed Shafik. All rights reserved.
//

import UIKit

class CustomImageViewLoader: UIImageView {
    private  var activityIndicator : UIActivityIndicatorView?
    var showLoading = true
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentMode = .scaleAspectFill
        self.isUserInteractionEnabled = true
        if showLoading {
        
        self.backgroundColor = .gray
        activityIndicator = UIActivityIndicatorView()
            activityIndicator?.isUserInteractionEnabled = true
        self.addSubview(activityIndicator!)
            self.addGesture()

        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: activityIndicator!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: activityIndicator!, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        self.addConstraints([horizontalConstraint,verticalConstraint])
        self.activityIndicator?.startAnimating()
        }
    }
    func loadImage(imageUrl : String){

            FileLoaderTask.shared.loadDataFromURL(imageUrl) { (result,fileObj) in
                if let currentImgeModel = fileObj {
                    currentImgeModel.isUsed = true
                    ImageCache.shared.save(object: currentImgeModel, forKey: imageUrl)
                }
                if self.showLoading {
                    if let activity = self.activityIndicator {
                        activity.stopAnimating()
                    }
                }
                self.image = result as? UIImage
                self.backgroundColor = .clear

            }
        
    }
    
    private func addGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelLoading))
        self.addGestureRecognizer(tap)

    }
    @objc private func cancelLoading(){
        FileLoaderTask.shared.cancelDownload()
        if let activity  = activityIndicator {
            activity.stopAnimating()
        }

    }
}
