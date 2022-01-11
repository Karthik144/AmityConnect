//
//  ElderOverview.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/22/21.
//

import Foundation

struct ElderOverview: Identifiable {
    
    var id: String = UUID().uuidString
    var age: String
    var gender: String
    var caretaker: String
    var condition: String
    var family_email: String
    var device_status: String?
    var name: String
}
