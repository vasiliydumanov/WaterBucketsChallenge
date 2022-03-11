//
//  AnimatedSolutionDataFlow.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 08.03.2022.
//

enum AnimatedSolutionDataFlow {
    enum Buckets {
        struct Response {
            let solutionWithInputs: SolutionWithInputs
            let iteratorElement: SolutionIteratorElement
        }
        
        struct ViewModel {
            let buckets: BucketsSolutionViewModel
            let solutionPosition: SolutionPosition
            
            enum SolutionPosition {
                case initial
                case intermediate
                case final
            }
        }
    }
}
