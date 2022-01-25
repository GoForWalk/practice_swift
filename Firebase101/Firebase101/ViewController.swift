//
//  ViewController.swift
//  Firebase101
//
//  Created by sae hun chung on 2022/01/25.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {

//    var db : DatabaseReference!
    
    let db = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        db.child("firstData").observeSingleEvent(of: .value) { snapshot in
            print("---> \(snapshot)")
        }
    }
    


}

