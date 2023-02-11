//
//  LoginViewController.swift
//  Messenger
//
//  Created by Đức Anh Trần on 31/01/2023.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class LoginViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signinLabel: UILabel!
    private var spinner: JGProgressHUD!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        configureView()
        print("DEBUG: LoginViewController: did load")
    }

    deinit {
        print("DEBUG: LoginViewController: deinit")
    }
    
    private func configureView() {
        // spinner
        spinner = JGProgressHUD(style: .light)
        spinner.textLabel.text = "Loading"
        
        // image view
        logoImageView.image = UIImage(named: "logo")
        
        // email text field
        emailTextField.delegate = self
        emailTextField.returnKeyType = .continue
        emailTextField.text = "duc1@gmail.com"
        emailTextField.placeholder = "Email..."
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        emailTextField.spellCheckingType = .no
        emailTextField.layer.cornerRadius = 12
        emailTextField.setBorder(color: .lightGray, width: 1)
        emailTextField.setPaddingPoints(left: 10, right: nil)
        emailTextField.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        // password text field
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .done
        passwordTextField.text = "password"
        passwordTextField.placeholder = "Password..."
        passwordTextField.autocorrectionType = .no
        passwordTextField.spellCheckingType = .no
        passwordTextField.layer.cornerRadius = 12
        passwordTextField.setBorder(color: .lightGray, width: 1)
        passwordTextField.setPaddingPoints(left: 10, right: nil)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        // log in button
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 12
        loginButton.addTarget(self, action: #selector(logInButtonDidTap), for: .touchUpInside)
        
        // sign in label
        let mutableString = NSMutableAttributedString(string: "Don't have an account? Sign In")
        mutableString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: NSRange(location: 23, length: 7))
        signinLabel.attributedText = mutableString
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signInLabelDidTap))
        signinLabel.isUserInteractionEnabled = true
        signinLabel.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Selector
    @objc private func logInButtonDidTap() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        spinner.show(in: view, animated: true)
        
        // Sign in user with Firebase API.
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                self?.spinner.dismiss(animated: true)
            }
            
            guard let auth = authResult, error == nil else {
                print("DEBUG: Cannot sign in User - error: \(error!.localizedDescription)")
                self?.handleAuthError(with: error)
                return
            }
            
            let userDocumentId = auth.user.uid
            
            // Fetch current user's info to save into UserDefaults.
            AuthManager.shared.fetchUser(withUserId: userDocumentId) { result in
                switch result {
                case .success(let user):
                    UserDefaults.standard.set(user.name, forKey: "name")
                    UserDefaults.standard.set(user.profileImageUrl, forKey: "profile_image_url")
                case .failure(let error):
                    print("DEBUG: LoginViewController: fetchUser() error: \(error.localizedDescription)")
                }
            }
            UserDefaults.standard.set(userDocumentId, forKey: "uid")
            print("DEBUG: LoginViewController: Successfully sign in user with email")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(
                MainTabBarViewController(),
                options: [.transitionCrossDissolve],
                animated: true)
        }
    }
    
    @objc private func signInLabelDidTap() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Helper
    private func handleAuthError(with error: Error?) {
        var errorMessage = ""
        
        if let error = error {
            guard let errorCode = AuthErrorCode.Code(rawValue: error._code) else {
                return
            }
            switch errorCode {
            case .invalidEmail:
                errorMessage = AuthManagerError.invalidEmail.rawValue
            case .wrongPassword:
                errorMessage = AuthManagerError.wrongPassword.rawValue
            case .userNotFound:
                errorMessage = AuthManagerError.userNotFound.rawValue
            default :
                errorMessage = error.localizedDescription
            }
        }
        
        presentAuthErrorAlert(with: errorMessage)
    }
    
    private func presentAuthErrorAlert(with message: String) {
        if message == AuthManagerError.userNotFound.rawValue {
            let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Sign In", style: .default, handler: { [weak self] _ in
                let vc = RegisterViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive))
            present(alert, animated: true)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
}


