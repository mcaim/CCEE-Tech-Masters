//
//  Quiz.swift
//  CCEEtest
//
//  Created by Macbook Pro on 4/15/19.
//

import Foundation

class Quiz {
    
    var questions = [Question]()
    
    struct AnswerList {
        var list = [String]()
        
        init(l: [String]){
            self.list = l
        }
    }
    
    struct Question {
        var answers = [AnswerList]()
        var num = -1
        var goalText = ""
        
        init(a: [AnswerList], n: Int, g: String) {
            self.answers = a
            self.num = n
            self.goalText = g
        }
    }
    
    init() {}
    
    init(q: [Question]) {
        self.questions = q
    }
    
    func checkAnswer(num: Int, answers: [String]) -> Bool {
        
        for a in self.questions[num - 1].answers {
            print(a.list)
            print(answers)
            if (a.list == answers) {
                return true
            }
        }
        
        return false
    }
    
}
