//
//  FeedViewController.swift
//  barterApp
//
//  Created by Kevin Maldjian on 2/26/19.
//  Copyright © 2019 Kevin Maldjian. All rights reserved.
//




import UIKit
import Firebase
import Kingfisher
import Hero

class FeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    private var cellsSizes = [CGSize]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    let items = ["1", "2", "1", "2","1", "2","1", "2","1", "2","1", "2","1", "2", "1", "2", "1", "2","1", "2","1", "2","1", "2","1", "2","1", "2", "1", "2", "1", "2","1", "2","1", "2","1", "2","1", "2","1", "2"]
    
    var barterItems: [BABarterItem] = []
    var serviceObserver: UInt?
    var passBarter : BABarterItem!
    var passImage : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hero.isEnabled = true
        
        view.accessibilityIdentifier = "homeFeed"
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.tabBarController?.tabBar.items?[0].image = UIImage(named: "home.png")
        self.tabBarController?.tabBar.tintColor = .black
        self.tabBarController?.tabBar.items?[0].selectedImage = UIImage(named: "homeSelected.png")
        
        //Navigation Setup
        setUp.feedNav(navItem: self.navigationItem)
        setUp.filterButton(navItem: self.navigationItem)
        setUp.setUpNav(navCon: self.navigationController!)
        
        //Search Bar Setup
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = "Search BarterApp"
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        }
        self.navigationController?.navigationBar.topItem?.titleView = searchBar

        //Collection View Setup
        if let layout = collectionView?.collectionViewLayout as? GridLayout {
            layout.delegate = self
        }
        collectionView.setContentOffset(CGPoint.zero, animated: false)
        cellsSizes = CellSizeProvider.provideSizes(items: items)
        collectionView.reloadData()
        
        observeServicesOnBackend()
        
    
    }
    
    @objc func dismissKeyboard() {
        self.navigationController?.navigationBar.topItem?.titleView!.endEditing(true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.navigationController?.navigationBar.topItem?.titleView!.endEditing(true)
    }
        

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return barterItems.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as! FeedCollectionViewCell
        //cell.background.backgroundColor = UIColor.random()
        cell.background.backgroundColor = .gray
        let index = barterItems.count - indexPath.row - 1
        let barterUrl = URL(string: barterItems[index].photoUrl)
        cell.itemPhoto.kf.setImage(with: barterUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on cell %d", indexPath)
        
        let cell = collectionView.cellForItem(at: indexPath) as! FeedCollectionViewCell
        passBarter = barterItems[indexPath.row]
        passImage = cell.itemPhoto.image
        print(passBarter.descr)
        performSegue(withIdentifier: "infoView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Anyone here")
        print(passBarter.descr)
        
//        if let vc = segue.destination.children[0] as? ItemInfoViewController {
//            vc.itemPhoto.image = passImage
//        }
//        
        //let vc = segue.destination as? ItemInfoViewController
        
//        let destinationNavigationController = segue.destination as! UINavigationController
//        let targetController = destinationNavigationController.topViewController as! ItemInfoViewController
//        targetController.itemPhoto.image = passImage
        //vc!.itemPhoto.image = passImage
        //vc!.barterItem = passBarter
    }
    
    
    @objc func observeServicesOnBackend() {
        serviceObserver = DataService.sharedInstance.FEED_REF.observe(.value, with: { snapshot in
            
            self.barterItems = []
            if let _ = snapshot.value as? NSNull {
                debugPrint("No bulletins available.")
            } else {
                if snapshot.hasChildren() {
                    for snapshot in snapshot.children {
                        let item = BABarterItem(snapshot: snapshot as! DataSnapshot)
                        self.barterItems.append(item)
                        print(item.title)
                    }
                }
                self.collectionView.reloadData()
            }
        })
    }
    
    
    @objc func sideMenu(){
        print("Over here")
    }
    

}

extension FeedViewController: ContentDynamicLayoutDelegate {
    func cellSize(indexPath: IndexPath) -> CGSize {
        return cellsSizes[indexPath.item]
    }
    
    
    }





