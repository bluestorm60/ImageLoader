//
//  FileModel.swift
//  ImagesLoader
//
//  Created by Ahmed Shafik on 7/29/19.
//  Copyright © 2019 Ahmed Shafik. All rights reserved.
//

import UIKit
class FileModel : NSObject {
    var fileType : String
    var fileObj : Data
    var isUsed : Bool
    init(fileType : String , fileObj : Data , isUsed : Bool) {
        self.fileType = fileType
        self.fileObj = fileObj
        self.isUsed = isUsed
    }
}
