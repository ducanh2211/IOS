//
//  RegisterViewController.swift
//  Messenger
//
//  Created by Đức Anh Trần on 31/01/2023.
//

import UIKit
import PhotosUI
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var validateFirstNameLabel: UILabel!
    @IBOutlet weak var validateLastNameLabel: UILabel!
    @IBOutlet weak var validateEmailLabel: UILabel!
    @IBOutlet weak var validatePasswordLabel: UILabel!
    
    private let spinner: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Loading"
        return hud
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create an Account"
        configureView()
    }
    
    deinit {
        print("RegisterViewController deinit")
    }
    
    // MARK: - Config View
    
    private func configureView() {
        // avatar image view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarImageViewDidTap))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGesture)
        
        avatarImageView.image = UIImage(systemName: "person.circle.fill")
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        avatarImageView.setBorder(color: .systemGray, width: 2)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        
        // first name text field
        firstNameTextField.delegate = self
        firstNameTextField.returnKeyType = .continue
        firstNameTextField.placeholder = "First name..."
        firstNameTextField.autocapitalizationType = .sentences
        firstNameTextField.autocorrectionType = .no
        firstNameTextField.spellCheckingType = .no
        firstNameTextField.layer.cornerRadius = 12
        firstNameTextField.setBorder(color: .lightGray, width: 1)
        firstNameTextField.setPaddingPoints(left: 10, right: nil)
        firstNameTextField.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        // first name validate label
        validateFirstNameLabel.isHidden = true
        validateFirstNameLabel.textColor = .red
        validateFirstNameLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        
        // last name text field
        lastNameTextField.delegate = self
        lastNameTextField.returnKeyType = .continue
        lastNameTextField.placeholder = "Last name..."
        lastNameTextField.autocapitalizationType = .sentences
        lastNameTextField.autocorrectionType = .no
        lastNameTextField.spellCheckingType = .no
        lastNameTextField.layer.cornerRadius = 12
        lastNameTextField.setBorder(color: .lightGray, width: 1)
        lastNameTextField.setPaddingPoints(left: 10, right: nil)
        lastNameTextField.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        // last name validate label
        validateLastNameLabel.isHidden = true
        validateLastNameLabel.textColor = .red
        validateLastNameLabel.font = .systemFont(ofSize: 15, weight: .regular)
        
        // email text field
        emailTextField.delegate = self
        emailTextField.returnKeyType = .continue
        emailTextField.placeholder = "Email..."
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        emailTextField.spellCheckingType = .no
        emailTextField.layer.cornerRadius = 12
        emailTextField.setBorder(color: .lightGray, width: 1)
        emailTextField.setPaddingPoints(left: 10, right: nil)
        emailTextField.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        // email validate label
        validateEmailLabel.isHidden = true
        validateEmailLabel.textColor = .red
        validateEmailLabel.font = .systemFont(ofSize: 15, weight: .regular)
        
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
        passwordTextField.autocorrectionType = .no
        passwordTextField.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        // password validate label
        validatePasswordLabel.isHidden = true
        validatePasswordLabel.textColor = .red
        validatePasswordLabel.font = .systemFont(ofSize: 15, weight: .regular)
        
        // register button
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        registerButton.backgroundColor = .systemGreen
        registerButton.layer.cornerRadius = 12
        registerButton.addTarget(self, action: #selector(registerButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Selector
    
    @objc private func avatarImageViewDidTap() {
        let actionSheet = UIAlertController(
            title: "Avatar",
            message: "Choose avatar for your account",
            preferredStyle: .actionSheet
        )
        actionSheet.addAction(
            UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
                self?.presentCamera()
            })
        )
        actionSheet.addAction(
            UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
                self?.presentPhotoLibrary()
            })
        )
        actionSheet.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        present(actionSheet, animated: true)
    }
    
    @objc private func registerButtonDidTap() {
        passwordTextField.resignFirstResponder()
        spinner.show(in: view, animated: true)
        
        guard let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let image = avatarImageView.image,
              let imageData = image.pngData() else { return }

        let isValidateInfo = validateTextField(firstName: firstName, lastName: lastName, email: email, password: password)
        guard isValidateInfo else {
            spinner.dismiss(animated: true)
            return
        }
        
        let authCredential = AuthCredential(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName,
            profileImageData: imageData
        )

        AuthManager.shared.registerUser(withAuthCredential: authCredential) { [weak self] error in
            DispatchQueue.main.async {
                self?.spinner.dismiss(animated: true)
            }
            
            guard error == nil else {
                print("DEBUG: RegisterVC - Failed to register user - error: \(error!)")
                self?.handleAuthCreateError(with: error)
                return
            }
            
            print("DEBUG: Sucessfully register user")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(
                MainTabBarViewController(),
                options: .transitionCrossDissolve,
                animated: true)
        }
    }
    
    // MARK: - Helper

    private func validateTextField(firstName: String, lastName: String, email: String, password: String) -> Bool {
        
        if !Validation.shared.checkValidateName(text: firstName) {
            showRegisterError(type: .firstNameError)
            return false
        } else if !Validation.shared.checkValidateName(text: lastName) {
            showRegisterError(type: .lastNameError)
            return false
        } else if !Validation.shared.checkValidateEmail(text: email) {
            showRegisterError(type: .emailError)
            return false
        } else if !Validation.shared.checkValidatePassword(text: password) {
            showRegisterError(type: .passwordError)
            return false
        }
        return true
    }
    
    private func showRegisterError(type: ValidationError) {
        switch type {
        case .firstNameError:
            validateFirstNameLabel.text = type.toString
            validateFirstNameLabel.isHidden = false
        case .lastNameError:
            validateLastNameLabel.text = type.toString
            validateLastNameLabel.isHidden = false
        case .emailError:
            validateEmailLabel.text = type.toString
            validateEmailLabel.isHidden = false
        case .passwordError:
            validatePasswordLabel.text = type.toString
            validatePasswordLabel.isHidden = false
        }
        
//        guard let firstName = firstNameTextField.text,
//              let lastName = lastNameTextField.text,
//              let email = emailTextField.text,
//              let password = passwordTextField.text else {
//            return
//        }
        
//        let alert = UIAlertController(
//            title: "Warning",
//            message: message,
//            preferredStyle: .alert
//        )
//
//        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
//        present(alert, animated: true)
    }
    
    private func handleAuthCreateError(with error: Error?) {
        var errorMessage = ""
        
        if let error = error {
            guard let errorCode = AuthErrorCode.Code(rawValue: error._code) else {
                return
            }
            
            switch errorCode {
            case .emailAlreadyInUse:
                errorMessage = AuthManagerError.emailAlreadyInUse.rawValue
            case .invalidEmail:
                errorMessage = AuthManagerError.invalidEmail.rawValue
            default:
                errorMessage = error.localizedDescription
            }
        }
        
        presentAuthErrorAlert(with: errorMessage)
    }
    
    private func presentAuthErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive))
        present(alert, animated: true)
    }
    
}

// MARK: - Image Picker Delegate
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func presentCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        avatarImageView.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
}

// MARK: - PH Picker Delegate
extension RegisterViewController: PHPickerViewControllerDelegate {
    
    private func presentPhotoLibrary() {
        let photoLibrary = PHPhotoLibrary.shared()
        
        var configuration = PHPickerConfiguration(photoLibrary: photoLibrary)
        configuration.filter = PHPickerFilter.images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
     
        guard !results.isEmpty else { return }
        
        let imageItems = results
            .map { $0.itemProvider }
            .filter { $0.canLoadObject(ofClass: UIImage.self) }
        
        for imageItem in imageItems {
            imageItem.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self?.avatarImageView.image = image
                    }
                }
            }
        }
    }
    
}

// MARK: - Text Field Delegate
extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
}
