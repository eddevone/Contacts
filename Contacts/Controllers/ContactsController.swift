//
//  ContactsController.swift
//  Contacts
//
//  Created by Eduard Churikov on 30.09.2021.
//

import UIKit

class ContactsController: UITableViewController {
    
    var contacts: [Contact] = []    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sizeSectionHeader()
        setSearchController(navigationItem: navigationItem)
    }
    
    func sizeSectionHeader(){
        tableView.estimatedSectionHeaderHeight = 40
        tableView.sectionHeaderHeight = UITableView.automaticDimension
    }
    
    @IBAction func addNewContact(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let NewContactsController = storyboard.instantiateViewController(identifier: "NewContactsController") as? NewContactsController else { return }
        NewContactsController.updateButtonOutlet.title = ""
        NewContactsController.navigationItem.title = "Создать контакт"
        show(NewContactsController, sender: nil)
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        guard segue.identifier == "SaveContactSegue" else { return }
        guard let NewContactsController = segue.source as? NewContactsController else { return }
        let contactNew = NewContactsController.contactNew
        let newIndexPath = IndexPath(row: contacts.count, section: 0)
        contacts.append(contactNew)
        tableView.insertRows(at: [newIndexPath], with: .fade)
    }
    
    @IBAction func updateUnwindSegue(unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.identifier == "UpdateContactSegue" else { return }
        guard let updateContact = unwindSegue.source as? NewContactsController else { return }
        let contactNew = updateContact.contactNew
        guard let selectedRow = tableView.indexPathForSelectedRow else { return }
        if searchController.isActive && !searchBarIsEmpty {
            filterContacts[selectedRow.row] = contactNew
        } else {
            contacts[selectedRow.row] = contactNew
        }
        tableView.reloadRows(at: [selectedRow], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && !searchBarIsEmpty {
            return filterContacts.count
        }
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ContactCell
        var contact: Contact
        if searchController.isActive && !searchBarIsEmpty {
            contact = filterContacts[indexPath.row]
        } else {
            contact = contacts[indexPath.row]
        }
        cell.name.text = contact.name
        cell.surname.text = contact.surname
        return cell
    }
    
    
    
    // MARK: - Удаление контакта свайпом
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: "Удалить") { _,_,_ in
            self.contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let ShowContactsController = storyboard.instantiateViewController(identifier: "ShowContactsController") as? ShowContactsController else { return }
        ShowContactsController.navigationItem.title = "Информация о контакте"
        show(ShowContactsController, sender: nil)
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let contact: Contact
        if searchController.isActive && !searchBarIsEmpty {
            contact = filterContacts[indexPath.row]
        } else {
            contact = contacts[indexPath.row]
        }
        ShowContactsController.showContact = contact
    }
    
    var filterContacts = [Contact]()
    let searchController = UISearchController(searchResultsController: nil)
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
}

//MARK: Extensions
extension ContactsController: UISearchResultsUpdating {
    func setSearchController(navigationItem: UINavigationItem) {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск контакта"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContactsInSearchBar(searchController.searchBar.text!)
    }
    
    private func filterContactsInSearchBar(_ searchText: String) {
        filterContacts = contacts.filter({ (contact: Contact) -> Bool in
            let surname = contact.surname?.lowercased().contains(searchText.lowercased()) ?? false
            let name = contact.name?.lowercased().contains(searchText.lowercased()) ?? false
            return name || surname
        })
        tableView.reloadData()
    }
    
    
}
