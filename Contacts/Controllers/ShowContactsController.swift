//
//  ShowContactsController.swift
//  Contacts
//
//  Created by Eduard Churikov on 01.10.2021.
//

import Foundation
import UIKit

class ShowContactsController: UITableViewController {
    
    var showContact = Contact(name: "", surname: "", birthday: "", phone: "", company: "", email: "")
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSurname: UILabel!
    @IBOutlet weak var labelBirthday: UILabel!

    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelCompany: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    override func viewDidLoad() {
      super.viewDidLoad()
      updateContact()
    }
    
    @IBAction func editContact(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let editTableController = storyboard.instantiateViewController(identifier: "NewContactsController") as? NewContactsController else { return }
        editTableController.saveButtonOutlet.title = ""
        editTableController.navigationItem.title = "Изменить контакт"
        show(editTableController, sender: nil)
        editTableController.contactNew = showContact
    }
    
    private func updateContact() {
        labelName.text = showContact.name
        labelSurname.text = showContact.surname
        labelBirthday.text = showContact.birthday
        labelPhone.text = showContact.phone
        labelCompany.text = showContact.company
        labelEmail.text = showContact.email
    }
    
}
