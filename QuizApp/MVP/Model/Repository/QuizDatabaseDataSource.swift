//
//  QuizDatabaseDataSource.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 28.05.2021..
//

import Foundation
import CoreData


class QuizDatabaseDataSource{
    private var coreDataContext: NSManagedObjectContext!
    
    init(coreDataContext: NSManagedObjectContext) {
        self.coreDataContext = coreDataContext
    }
}
