//
//  FilterSettings.swift
//  QuizApp
//
//  Created by Five on 29.05.2021..
//

import Foundation

struct FilterSettings {

    let searchText: String?

    init(searchText: String? = nil) {
        self.searchText = (searchText?.isEmpty ?? true) ? nil : searchText
    }
}
