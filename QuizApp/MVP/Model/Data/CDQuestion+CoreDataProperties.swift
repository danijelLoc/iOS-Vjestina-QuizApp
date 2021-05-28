//
//  CDQuestion+CoreDataProperties.swift
//  
//
//  Created by Danijel Stracenski on 28.05.2021..
//
//

import Foundation
import CoreData


extension CDQuestion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDQuestion> {
        return NSFetchRequest<CDQuestion>(entityName: "CDQuestion")
    }

    @NSManaged public var answers: [String]?
    @NSManaged public var correctAnswer: Int64
    @NSManaged public var id: Int64
    @NSManaged public var question: String?

}
