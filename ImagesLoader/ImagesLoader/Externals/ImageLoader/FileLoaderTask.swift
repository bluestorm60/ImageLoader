//
//  ImageLoaderTask.swift
//  ImagesLoader
//
//  Created by Ahmed Shafik on 7/28/19.
//  Copyright © 2019 Ahmed Shafik. All rights reserved.
//

import UIKit
enum DataType : String {
    case image
    case json
    case xml
}
let isUsed = "isUsed"
class FileLoaderTask: NSObject {
    public typealias SucessBlock = (_ object:Any? , _ FileModel: FileModel?) -> Void

    var currentTask : URLSessionTask!
    var urlString : String?
    var currentDataType : DataType = .image
    static let shared = FileLoaderTask()
    public var numberFiles = 10
    //load task
    func loadDataFromURL(_ url : String , completion : @escaping SucessBlock){
        urlString = url
//        ImageCache.shared.setCacheCapicity(fileNum: self.numberFiles)
        if let cachedObj = ImageCache.shared.get(forKey: url) {
            completion(UIImage(data: cachedObj.fileObj),cachedObj)
            return
        }
        if let url = URL(string: url) {
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                if let unwrappedError = error {
                    print(unwrappedError)
                    return
                }
                
                if let unwrappedData = data {
                    DispatchQueue.main.async(execute: {
                        let newData = FileModel(fileType: self.currentDataType.rawValue, fileObj: unwrappedData, isUsed: false)
                        ImageCache.shared.save(object: newData, forKey: self.urlString!)
                        self.handleJson(url : self.urlString! , data: unwrappedData, completion: { (result,fileModel) in
                            completion(result,fileModel)
                        })
                    })
                }
            }
            currentTask = dataTask
            dataTask.resume()
        }
        
    }
    private func handleJson(url : String , data : Data , completion : @escaping SucessBlock) {
        switch currentDataType {
        case .image:
            self.handleImgeData(url: url, imgData: data, completion: completion)
        case .json:
            self.handleJsonData(url: url, jsonData: data, completion: completion)
        case .xml:
            self.handleXMLData(url: url, xmlData: data, completion: completion)
            
        }
    }
    private func handleImgeData(url : String , imgData : Data , completion : @escaping SucessBlock) {
        if let downloadedImage = ImageCache.shared.get(forKey: url) {
            if let downloadedImageFile = UIImage(data: downloadedImage.fileObj)  {
                if self.urlString == url {
                    completion(downloadedImageFile , downloadedImage)
                }
            }

        }
    }
    private func handleJsonData(url : String , jsonData : Data , completion : @escaping SucessBlock) {
        
    }
    private func handleXMLData(url : String , xmlData : Data , completion : @escaping SucessBlock) {
        
    }
    
}
extension FileLoaderTask {
     func cancelDownload(){
        weak var oldTask = currentTask
        currentTask = nil
        oldTask?.cancel()
    }
    
}
