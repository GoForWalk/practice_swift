//
//  LoginViewController.swift
//  SpotifyStyleLogin
//
//  Created by sae hun chung on 2022/03/02.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [emailLoginButton, googleLoginButton, appleLoginButton].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.layer.cornerRadius = 30
        }
    } //: viewDidLoad
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Navigation bar 숨기기
        navigationController?.navigationBar.isHidden = true
       
    }//: viewWillAppear
    
    private func googleSignInFlow() {
        // firebase 인증코드
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // create Google Sign In configration object
        let config = GIDConfiguration(clientID: clientID)
        
        // Start sign in flow
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
            // error 처리
            if let error = error {
                print("---> google sign in error: \(error.localizedDescription)")
                return
            }
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { authResult, error in
                guard error == nil else { return }
                self.showMainViewController()
            }
        }
    } //: googleSignInFlow
    
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        UIApplication.shared.windows.first?.rootViewController?.show(mainViewController, sender: nil)
        
    } //: showMainViewController
    
    
    @IBAction func googleLoginButtonTapped(_ sender: GIDSignInButton) {
        googleSignInFlow()
    
    } //: googleLoginButtonTapped
    
    @IBAction func appleLoginButtonTapped(_ sender: UIButton) {
        // firebase 인증코드
    }
    
}
