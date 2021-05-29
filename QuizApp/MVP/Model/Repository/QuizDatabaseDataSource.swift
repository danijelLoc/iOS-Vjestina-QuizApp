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
    
    func fetchQuizzesFromCoreData(filter: FilterSettings) -> [Quiz] {
        let request: NSFetchRequest<CDQuiz> = CDQuiz.fetchRequest()
        var namePredicate = NSPredicate(value: true)

        if let text = filter.searchText, !text.isEmpty {
            namePredicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(CDQuiz.title), text)
        }

        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [namePredicate])
        request.predicate = andPredicate
        do {
            return try coreDataContext.fetch(request).map { Quiz(with: $0) }
        } catch {
            print("Error when fetching quizzes from core data: \(error)")
            return []
        }
    }
    
    func saveNewQuizzes(_ quizzes: [Quiz]) {
        do {
            let newIds = quizzes.map { $0.id }
            try deleteAllQuizzesExcept(withId: newIds)
        }
        catch {
            print("Error when deleting quizzes from core data: \(error)")
        }

        quizzes.forEach { quiz in
            do {
                let cdQuiz = try fetcQuiz(withId: quiz.id) ?? CDQuiz(context: coreDataContext)
                quiz.populate(cdQuiz, in: coreDataContext)
            } catch {
                print("### Error when fetching/creating a quiz: \(error)")
            }

            do {
                try coreDataContext.save()
            } catch {
                print("#### Error when saving updated quiz: \(error)")
            }
        }
    }
    
    private func fetcQuiz(withId id: Int) throws -> CDQuiz? {
        let request: NSFetchRequest<CDQuiz> = CDQuiz.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %u", #keyPath(CDQuiz.id), id)

        let cdResponse = try coreDataContext.fetch(request)
        return cdResponse.first
    }
    
    func deleteQuiz(withId id: Int) {
        guard let quiz = try? fetcQuiz(withId: id) else { return }

        coreDataContext.delete(quiz)

        do {
            try coreDataContext.save()
        } catch {
            print("Error when saving after deletion of quiz: \(error)")
        }
    }
    
    private func deleteAllQuizzesExcept(withId ids: [Int]) throws {
        let request: NSFetchRequest<CDQuiz> = CDQuiz.fetchRequest()
        request.predicate = NSPredicate(format: "NOT %K IN %@", #keyPath(CDQuiz.id), ids)

        let quizzesToDelete = try coreDataContext.fetch(request)
        quizzesToDelete.forEach { coreDataContext.delete($0) }
        try coreDataContext.save()
    }
    
    private func deleteAllQuizzes() throws {
        let request: NSFetchRequest<CDQuiz> = CDQuiz.fetchRequest()

        let quizzesToDelete = try coreDataContext.fetch(request)
        quizzesToDelete.forEach { coreDataContext.delete($0) }
        try coreDataContext.save()
    }


}
