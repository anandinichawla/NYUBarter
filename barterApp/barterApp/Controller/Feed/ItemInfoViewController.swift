//
//  ItemInfoViewController.swift
//  barterApp
//
//  Created by Kevin Maldjian on 4/9/19.
//  Copyright © 2019 Kevin Maldjian. All rights reserved.
//

import UIKit

class ItemInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp.setUpPicNav(navCon: self.navigationController!)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backToFeed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
