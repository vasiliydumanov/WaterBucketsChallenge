//
//  InputsDataFlow.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 03.03.2022.
//

struct RawInputs {
    let x: String?
    let y: String?
    let z: String?
}

enum InputsDataFlow {
    enum Update {
        typealias Request = RawInputs
        
        struct Response {
            let isReadyToSolve: Bool
        }
        
        struct ViewModel {
            let isSolveButtonEnabled: Bool
        }
    }
    
    enum Solve {
        struct Request {
            let rawInputs: RawInputs
        }
        
        struct Response {
            let solution: Result<Solution, SolutionError>
        }
        
        enum ViewModel {
            case solved(Solution)
            case notSolvable(message: String)
        }
    }
}
