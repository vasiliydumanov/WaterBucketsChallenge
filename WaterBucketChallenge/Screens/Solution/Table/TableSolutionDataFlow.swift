//
//  TableSolutionDataFlow.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 04.03.2022.
//

struct TableSolutionSection {
    let items: [TableSolutionSectionItem]
}

struct TableSolutionSectionItem {
    let text: String
    let kind: Kind
    
    enum Kind {
        case header
        case filledVolume(isSolution: Bool)
        case explanation
    }
}

enum TableSolutionDataFlow {
    struct Response {
        let solution: Solution
    }
    
    struct ViewModel {
        let sections: [TableSolutionSection]
    }
}
