//
//  HealthData.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 1/5/22.
//

import Foundation

struct HealthData: Identifiable {

    var id: String = UUID().uuidString
    var name: String
    var blood_pressure: String
    var date: Date
    var glucose_level: String
    var heart_rate: String
    var oxidation_level: String
}
