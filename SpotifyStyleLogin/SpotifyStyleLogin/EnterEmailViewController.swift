//
//  EnterEmailViewController.swift
//  SpotifyStyleLogin
//
//  Created by sae hun chung on 2022/03/03.
//

import UIKit
import FirebaseAuth

class EnterEmailViewController: UIViewController {
    
    @IBOutlet weak var emailITextIField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.layer.cornerRadius = 30
        
        // 이메일 & 비밀번호 미 입력시 비활성화
        nextButton.isEnabled = false
        
        // textField에 입력된 내용을 가져오기 위해서는 delegate에 연결이 필요하다.
        emailITextIField.delegate = self
        passwordTextField.delegate = self
        
        // 초기 커서 위치 지정 -> emailTextField
        emailITextIField.becomeFirstResponder()
        
    } //: viewDidLoad
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Nav bar 보이기
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
    } //: viewWillAppear
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        print("nextButtonTapped")
        // firebase email/pw auth
        let email = emailITextIField.text ?? "" // optional 처리
        let password = passwordTextField.text ?? ""
        
        // 신규사용자 생성
        Auth.auth().createUser(withEmail: email, password: password) {[weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                let code = (error as NSError).code
                print("---> error code: \(code), error message: \(error.localizedDescription)")
                switch code {
                case 17007: // 이미 가입한 계정일 경우
                    // 로그인하기
                    self.loginUser(withEmail: email, password: password)
                default:
                    self.errorMessageLabel.text = error.localizedDescription
                }
            } else {
                self.showMainViewController()
            }
        }
    } //: nextButtonTapped
    
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        navigationController?.show(mainViewController, sender: nil)
    } //: showMainViewController
    
    private func loginUser(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.errorMessageLabel.text = error.localizedDescription
            } else {
                self.showMainViewController()
            }
        }
        
    }//: loginUser
    
} //: EnterEmailViewController

// textFieldDelegate 설정
extension EnterEmailViewController: UITextFieldDelegate {
    // 이메일, 비밀번호 입력 후 return누르면 키보드 들어가도록
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    } //: textFieldShouldReturn
    
    // 이메일과 비밀번호가 입력 된 후, '다음' 버튼이 작동하도록 하는 기능
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = emailITextIField.text == ""
        let isPassWordEmpty = passwordTextField.text == ""
        
        nextButton.isEnabled = !isEmailEmpty && !isPassWordEmpty
    } //: textFieldDidEndEditing
    
}//: extension EnterEmailViewController
