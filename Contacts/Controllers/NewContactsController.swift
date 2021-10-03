//
//  NewContactsController.swift
//  Contacts
//
//  Created by Eduard Churikov on 01.10.2021.
//

import Foundation
import UIKit

class NewContactsController: UITableViewController {
    var contactNew = Contact(name: "", surname: "", birthday: "", phone: "", company: "", email: "")
    
    @IBOutlet weak var updateButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var saveButtonOutlet: UIBarButtonItem!
    
    @IBOutlet weak var nameNew: UITextField!
    @IBOutlet weak var surnameNew: UITextField!
    @IBOutlet weak var phoneNew: UITextField!
    
    @IBOutlet weak var birthdayNew: UITextField!
    @IBOutlet weak var companyNew: UITextField!
    @IBOutlet weak var emailNew: UITextField!
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldsDelegates()
        activeSaveButton()
        updateContact()
    }
    
    // MARK: - Поля Имя и Фамилия заполняются только буквами
    @IBAction func nameSurnameFieldsValid(_ sender: UITextField) {
        let ruChar = "йцукенгшщзхъфывапролджэёячсмитьбю"
        let engCharacters = "qwertyuiopasdfghjklzxcvbnm"
        guard let lastChar = sender.text?.last?.description.lowercased() else { return }
        guard ruChar.contains(lastChar) || engCharacters.contains(lastChar) else {
            sender.text?.removeLast()
            return
        }
    }
    
    // MARK: - Поле номер телефона заполняется только цифрами
    @IBAction func phoneFieldValid(_ sender: UITextField) {
        let numbers = "0123456789"
        guard let lastChar = sender.text?.last?.description.lowercased() else { return }
        guard numbers.contains(lastChar) else {
            sender.text?.removeLast()
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "SaveContactSegue" || segue.identifier == "UpdateContactSegue" else { return }
        self.updateNewContact()
    }
    
    private func updateContact() {
        nameNew.text = contactNew.name
        surnameNew.text = contactNew.surname
        birthdayNew.text = contactNew.birthday
        
        phoneNew.text = contactNew.phone
        companyNew.text = contactNew.company
        emailNew.text = contactNew.email
    }
    
    private func updateNewContact() {
        let name = nameNew.text ?? ""
        let surname = surnameNew.text ?? ""
        let birthday = birthdayNew.text ?? ""
        
        let phone = phoneNew.text ?? ""
        let company = companyNew.text ?? ""
        let email = emailNew.text ?? ""
        
        
        contactNew = Contact(name: name, surname: surname, birthday: birthday, phone: phone, company: company, email: email)
    }
    
    // MARK: - Активация кнопки "Сохранить"
    @IBAction func activSaveButton(_ sender: UITextField) {
        activeSaveButton()
    }
    
    private func activeSaveButton() {
        let name = nameNew.text ?? ""
        let surname = surnameNew.text ?? ""
        let dateOfBirth = birthdayNew.text ?? ""
        let company = companyNew.text ?? ""
        let email = emailNew.text ?? ""
        let phoneNumber = phoneNew.text ?? ""
        saveButtonOutlet.isEnabled = !name.isEmpty && !surname.isEmpty && !dateOfBirth.isEmpty && !company.isEmpty && !email.isEmpty && !phoneNumber.isEmpty
    }
}

//MARK: Extensions NewContactsController
extension NewContactsController: UITextFieldDelegate {
    
    func textFieldsDelegates() {
        nameNew.delegate = self
        surnameNew.delegate = self
        birthdayNew.delegate = self
        
        phoneNew.delegate = self
        companyNew.delegate = self
        emailNew.delegate = self
    }
    
    
    
    // MARK: - Проверка email
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == emailNew {
            if emailNew.text?.isValidEmail == false {
                let alertController = UIAlertController(title: "Некорректный email", message: nil, preferredStyle: .alert)
                let okey = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
                alertController.addAction(okey)
                present(alertController, animated: true, completion: nil)
            }
        }
        return true
    }
    
    // MARK: - Работа с dataPicker
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == birthdayNew {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.datePickerMode = .date
            datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            textField.inputView = datePicker
        }
    }
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        birthdayNew.text = dateFormatter.string(from: sender.date)
    }
}
//MARK: Extensions String
extension String {
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
}
