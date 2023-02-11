//
//  Validation.swift
//  Messenger
//
//  Created by Đức Anh Trần on 09/02/2023.
//

import Foundation

enum ValidationError {
    case firstNameError
    case lastNameError
    case emailError
    case passwordError
    
    var toString: String {
        switch self {
        case .firstNameError:
            return "your name is too short"
        case .lastNameError:
            return "your name is too short"
        case .emailError:
            return "email is invalid form"
        case .passwordError:
            return "your password is too weak"
        }
    }
}

/// The struct to validate user info
struct Validation {
    static let shared = Validation()
     
    private init() {}
    
    public func checkValidateName(text: String) -> Bool {
        // Length be 18 characters max and 3 characters minimum
        let nameRegex = "^\\w{3,18}$"
        let trimmedString = text.trimmingCharacters(in: .whitespaces)
        let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValidateName = validateName.evaluate(with: trimmedString)
        return isValidateName
    }
    
    public func checkValidateEmail(text: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let trimmedString = text.trimmingCharacters(in: .whitespaces)
        let validateEmail = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValidateEmail = validateEmail.evaluate(with: trimmedString)
        return isValidateEmail
    }
    
    public func checkValidatePassword(text: String) -> Bool {
        // Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet and 1 Number
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        let trimmedString = text.trimmingCharacters(in: .whitespaces)
        let validatePassord = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        let isvalidatePass = validatePassord.evaluate(with: trimmedString)
        return isvalidatePass
    }
}
