//
//  Utilities.swift
//  egoChat
//
//  Created by JohnPiaPian on 4/20/21.
//

import Foundation
import UIKit


public func validateName(name: String) -> Bool {
  // Length be 18 characters max and 3 characters minimum, you can always modify.
  let nameRegex = "^\\w{3,18}$"
  let trimmedString = name.trimmingCharacters(in: .whitespaces)
  let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
  let isValidateName = validateName.evaluate(with: trimmedString)
  return isValidateName
}

public func checkTextFieldIsNotEmpty(text:String) -> Bool
{
    if (text.trimmingCharacters(in: .whitespaces).isEmpty)
    {
        return false

    }else{
        return true
    }
}

public func invalidInput(field: UITextField){
    field.layer.cornerRadius = 10
    field.layer.borderWidth = 1
    field.layer.borderColor = UIColor.red.cgColor
}

public func clearInvalidInput(filed: UITextField){
    filed.layer.borderWidth = 0
}
