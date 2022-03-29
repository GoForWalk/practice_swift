//
//  MainViewController.swift
//  SpotifyStyleLogin
//
//  Created by sae hun chung on 2022/03/03.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var welcomeText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }//: viewDidLoad
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        let email = Auth.auth().currentUser?.email ?? "고객"
        
        welcomeText.text = """
        환영합니다.
        \(email)님
        """
        
        appearChangePWButton()
    }//: viewWillAppear
    
    // email로 로그인 했을 경우에만 해당 버튼 노출
    private func appearChangePWButton() {
        let isEmailSignIn = Auth.auth().currentUser?.providerData[0].providerID == "password"
        
        self.changePasswordButton.isHidden = !isEmailSignIn
    }// : appearChangePWButton
    
    // 비밀변호 변경
    // 로그인 이메일로 PW 변경 이메일 송신
    @IBAction func changePasswordButtonTapped(_ sender: UIButton) {
        let email = Auth.auth().currentUser?.email ?? ""
        Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
        
    } //: changePasswordButtonTapped
    
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("---> Error: \(signOutError.description)")
        }
        self.navigationController?.popToRootViewController(animated: true)
    }//: logoutButtonTapped
    
}//: MainViewController
