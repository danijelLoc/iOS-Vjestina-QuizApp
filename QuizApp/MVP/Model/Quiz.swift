import CoreData

struct Quiz: Codable {

    let id: Int
    let title: String
    let description: String
    let category: QuizCategory
    let level: Int
    let imageUrl: String
    let questions: [Question]
    
    
    init(with entity:CDQuiz){
        id = Int(entity.id)
        title = entity.title
        description = entity.description_
        category = QuizCategory(rawValue: entity.category)!
        level = Int(entity.level)
        imageUrl = entity.imageUrl
        questions = (entity.questions.allObjects as! [CDQuestion]).map({Question(with: $0)})
    }
    
    func populate(_ entity: CDQuiz, in context: NSManagedObjectContext) {
        entity.id = Int32(id)
        entity.title = title
        entity.description_ = description
        entity.category = category.rawValue
        entity.level = Int32(level)
        entity.imageUrl = imageUrl
        entity.questions = NSSet(array: (questions).map({ question -> CDQuestion in
            let cdQuestion = CDQuestion(context: context)
            cdQuestion.id = Int32(question.id)
            cdQuestion.correctAnswer = Int32(question.correctAnswer)
            cdQuestion.answers = question.answers
            cdQuestion.question = question.question
            return cdQuestion
        }))
        
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case category
        case level
        case imageUrl = "image"
        case questions
    }
    
}
