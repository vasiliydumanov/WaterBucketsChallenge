//
//  SolutionDataFlow.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 04.03.2022.
//

struct SolutionSection {
    let items: [SolutionSectionItem]
}

struct SolutionSectionItem {
    let text: String
    let kind: Kind
    
    enum Kind {
        case header
        case filledVolume(isSolution: Bool)
        case explanation
    }
}

enum SolutionDataFlow {
    struct Response {
        let solution: Solution
    }
    
    struct ViewModel {
        let sections: [SolutionSection]
    }
}
