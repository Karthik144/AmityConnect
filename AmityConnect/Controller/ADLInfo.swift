//
//  ADLInfo.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/28/21.
//

import Foundation


struct ADLInfo: Identifiable {

    var id: String = UUID().uuidString
    var type: String
    var date: String
    var activity_1: String?
    var activity_2: String?
    var activity_3: String?
    var activity_4: String?
    var activity_5: String?
    var activity_6: String?
}
