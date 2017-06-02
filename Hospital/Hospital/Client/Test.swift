//
//  Test.swift
//  Hospital
//
//  Created by lieon on 2017/6/1.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation

class Test {
    func testPerson() {
        let personBulider = Person.Builder()
        personBulider.email = "lieoncx@gmail.com"
        personBulider.id = 21
        personBulider.name = "lieon"
        let phoneNumber = Person.PhoneNumber.Builder()
        phoneNumber.number = "15608066219"
        phoneNumber.type = .home
        personBulider.phones = [try! phoneNumber.build()]
        let address = AddressBook.Builder()
        address.people = [try! personBulider.build()]
        print(address)

    }
}
