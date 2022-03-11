//
//  AnimatedSolutionPresenter.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 08.03.2022.
//

protocol AnimatedSolutionPresentationLogic: AnyObject {
    func presentBuckets(_ response: AnimatedSolutionDataFlow.Buckets.Response)
}

final class AnimatedSolutionPresenter: AnimatedSolutionPresentationLogic {
    weak var viewController: AnimatedSolutionDisplayLogic?
    
    // MARK: - AnimatedSolutionPresentationLogic
    
    func presentBuckets(_ response: AnimatedSolutionDataFlow.Buckets.Response) {
        let inputs = response.solutionWithInputs.inputs
        let solution = response.solutionWithInputs.solution
        
        let bucketsState: BucketsSolutionViewModel.State
        let solutionPosition: AnimatedSolutionDataFlow.Buckets.ViewModel.SolutionPosition
        
        switch response.iteratorElement {
        case .start:
            bucketsState = .initial
            solutionPosition = .initial
        case let .step(step):
            bucketsState = .intermediate(step: step)
            solutionPosition = .intermediate
        case .end:
            bucketsState = .final(
                xBucketState: .init(
                    filledVolume: solution.steps.last?.xFilledVolume ?? 0,
                    containsTargetVolume: solution.xContainsTargetVolume
                ),
                yBucketState: .init(
                    filledVolume: solution.steps.last?.yFilledVolume ?? 0,
                    containsTargetVolume: solution.yContainsTargetVolume
                )
            )
            solutionPosition = .final
        }
        
        viewController?.showBuckets(
            .init(
                buckets: .init(
                    xVolume: inputs.x,
                    yVolume: inputs.y,
                    state: bucketsState
                ),
                solutionPosition: solutionPosition
            )
        )
    }
}
