import Foundation
import UIKit
import CoreData

class AddContactsViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    var ref = ContactsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.borderStyle = .none
        lastNameTextField.borderStyle = .none
        phoneTextField.borderStyle = .none
        
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                  for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                  for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                  for: .editingChanged)
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        phoneTextField.delegate = self
        
        doneButton.isEnabled = false
        
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if ((firstNameTextField.text != "") && (lastNameTextField.text != "") && (phoneTextField.text != "")) {
            doneButton.isEnabled = true
        }
        else {
            doneButton.isEnabled = false
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        let saveContactSuccess = saveContact(firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, phone: phoneTextField.text!)
        if (saveContactSuccess) {
            ref.refreshData()
            self.dismiss(animated: true)
        }
        else {
            showErrorAlert(errorMessage: "Error saving contact. Please try again later")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func saveContact(firstName: String, lastName: String, phone: String) -> Bool {
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return false
      }
      
      let managedContext = appDelegate.persistentContainer.viewContext
      let entity = NSEntityDescription.entity(forEntityName: "Contact", in: managedContext)!
      let contact = NSManagedObject(entity: entity, insertInto: managedContext)
        
      contact.setValue(firstName, forKey: "firstName")
      contact.setValue(lastName, forKey: "lastName")
      contact.setValue(phone, forKey: "phone")
      
      do {
        try managedContext.save()
      } catch {
          return false
      }
        return true
    }
    
    func showErrorAlert(errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

