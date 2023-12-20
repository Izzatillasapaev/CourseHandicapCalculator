//
//  CalculatorViewModel.swift
//  CourseHandicapCalculator
//
//  Created by Izzatilla on 20.12.2023.
//

import Foundation
import Combine

enum CalculatorEvent {
    case showError(String)
    case showResult(Int)
}

enum CalculatorAction {
    case calculate(params: CourseHandicapParamsModel)
}

final class CalculatorViewModel: ViewModel<CalculatorEvent, CalculatorAction> {
    
    override func handleAction(_ action: CalculatorAction) {
        switch action {
        case .calculate(let params):
            processCalculation(params: params)
        }
    }
    
    private func processCalculation(params: CourseHandicapParamsModel) {
        guard let handicapIndex = Double(params.handicapIndex) else {
            sendEvent(.showError("Handicap Index Field has Incorrect Format or Empty"))
            return
        }
        guard let slopeRating = Double(params.slopeRating) else {
            sendEvent(.showError("Slope Rating Field has Incorrect Format or Empty"))
            return
        }
        guard let coureRating = Double(params.coureRating) else {
            sendEvent(.showError("Course Rating Field has Incorrect Format or Empty"))
            return
        }
        guard let par = Double(params.par) else {
            sendEvent(.showError("Par Field has Incorrect Format or Empty"))
            return
        }
        guard handicapIndex < 55 else {
            sendEvent(.showError("The maximum Handicap Index a player can have is 54.0"))
            return
        }
        guard (55..<155) ~= slopeRating else {
            sendEvent(.showError("Slope Rating must be 55 to 155"))
            return
        }
        guard (20..<90) ~= par else {
            sendEvent(.showError("Par must be 20 to 90"))
            return
        }
        
        let courseHandicap = (handicapIndex * (slopeRating / 113) + (coureRating - par)).rounded()
        
        sendEvent(.showResult(Int(courseHandicap)))
    }
}
