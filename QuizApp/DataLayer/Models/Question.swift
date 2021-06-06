struct Question : Codable{

    let id: Int
    let question: String
    let answers: [String]
    let correctAnswer: Int
    
    init(with entity:CDQuestion){
        id = Int(entity.id)
        question = entity.question
        answers = entity.answers
        correctAnswer = Int(entity.correctAnswer)
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case question
        case answers
        case correctAnswer = "correct_answer"
    }

}
