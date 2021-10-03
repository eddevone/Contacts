//
//  Contact.swift
//  Contacts
//
//  Created by Eduard Churikov on 30.09.2021.
//

import Foundation

protocol ContactProtocol {
    var name: String? { get set }
    var surname: String? { get set }
    var birthday: String? { get set }
    
    var phone: String? { get set }
    var company: String? { get set }
    var email: String? { get set }
    
    
}

struct Contact: ContactProtocol {
    
    var name: String?
    var surname: String?
    var birthday: String?
    var phone: String?
    var company: String?
    var email: String?
    
}
