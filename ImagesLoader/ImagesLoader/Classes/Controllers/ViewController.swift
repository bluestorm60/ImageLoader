//
//  ViewController.swift
//  ImagesLoader
//
//  Created by Ahmed Shafik on 7/27/19.
//  Copyright © 2019 Ahmed Shafik. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {
    @IBOutlet weak var pinBoardCollectionView: UICollectionView!
    var list : [ResultObj]?
    var refreshControl : UIRefreshControl?
    lazy var client = PinboardHandler(session: URLSession.shared)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        reloadCollection()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadList()
    }
    
    
}

extension ViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PinBoardCustomCollectionViewCell", for: indexPath) as! PinBoardCustomCollectionViewCell
        let item = list![indexPath.row]
        cell.imageView.loadImage(imageUrl: item.urls.regular)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let item = list![indexPath.row]
        
        return  CGSize(width: ((((UIScreen.main.bounds.width / 2) - 10) / CGFloat(item.width)) *  CGFloat(item.width))-10, height: ((UIScreen.main.bounds.width / 2)  / CGFloat(item.width)) * CGFloat(item.height))
    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //        return 5
    //    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    //        return 5
    //    }
}
extension ViewController: PinboardLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        let item = list![indexPath.row]
        
        return ((UIScreen.main.bounds.width / 2)  / CGFloat(item.width)) * CGFloat(item.height)
    }
}
public extension UIImage {
    /**
     Calculates the best height of the image for available width.
     */
    func height(forWidth width: CGFloat) -> CGFloat {
        let boundingRect = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: CGFloat(MAXFLOAT)
        )
        let rect = AVMakeRect(
            aspectRatio: size,
            insideRect: boundingRect
        )
        return rect.size.height
    }
}
//refresh control
extension ViewController {
    private func reloadCollection(){
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(self.refreshWebView(_:)), for: UIControl.Event.valueChanged)
        self.pinBoardCollectionView.addSubview(refreshControl!)
    }
    @objc func refreshWebView(_ sender: UIRefreshControl) {
        print("refersh")
        if let refresh = self.refreshControl {
            refresh.beginRefreshing()
        }
        
        self.loadList()
    }
    
}

extension ViewController {
    private func loadList(){
        client.loadPinboardService { [unowned self] (result) in
            switch result {
            case .success(let user):
                let users = user
                print(user)
                self.list = users
                self.pinBoardCollectionView.dataSource = self
                self.pinBoardCollectionView.delegate = self
                if let layout = self.pinBoardCollectionView.collectionViewLayout as? PinboardCustomLayout {
                    layout.delegate = self
                }
                if let refresh = self.refreshControl {
                    refresh.endRefreshing()
                }
            case .error(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}
