//
//  AppTabbarController.swift
//  MyNetfilxPlayer
//
//  Created by sae hun chung on 2022/01/21.
//

import UIKit

class AppTabbarController: UITabBarController {

    override var shouldAutorotate: Bool {
         return false
     }
     
     override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
         return .portrait
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
