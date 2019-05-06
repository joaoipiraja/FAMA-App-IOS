//
//  Artist.swift
//  FAMAApp
//
//  Created by João Pedro Aragão on 26/04/19.
//  Copyright © 2019 FAMA. All rights reserved.
//

import Foundation

struct Artist: Codable {
    var name: String
    var number: Int
    var isPresenting: Bool
    var eventName: String {
        return "Atração \(number) - \(name)"
    }
}
