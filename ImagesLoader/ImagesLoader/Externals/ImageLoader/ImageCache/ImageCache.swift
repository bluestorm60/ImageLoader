//
//  ImageCache.swift
//  ImagesLoader
//
//  Created by Ahmed Shafik on 7/27/19.
//  Copyright © 2019 Ahmed Shafik. All rights reserved.
//

import UIKit

class ImageCache {
    private let cache = NSCache<NSString, FileModel>()
    private var observer: NSObjectProtocol!
    
    static let shared = ImageCache()
    
    private init() {
        observer = NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil, queue: nil) { [weak self] notification in
                self?.cache.removeAllObjects()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(observer)
    }
     func setCacheCapicity(fileNum : Int){
        let memoryCapacity = fileNum * 1024 * 1024
        let diskCapacity = fileNum * 1024 * 1024
        let urlCache = URLCache(memoryCapacity: memoryCapacity,
                                diskCapacity: diskCapacity,
                                diskPath: "myCachePath")
        URLCache.shared = urlCache
    }
    func getImage(forKey key: String) -> AnyObject? {
        return cache.object(forKey: key as NSString)
    }
    
//    func save(image: UIImage, forKey key: String) {
//        cache.setObject(image, forKey: key as NSString)
//    }
    func save(object : FileModel , forKey key: String){
        cache.setObject(object, forKey: key as NSString)
    }
    func get(forKey key: String) -> FileModel? {
        return cache.object(forKey: key as NSString)
    }


}
