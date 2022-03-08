//
//  TableSolutionPresenter.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 04.03.2022.
//

protocol TableSolutionPresentationLogic: AnyObject {
    func presentSolution(_ response: TableSolutionDataFlow.Response)
}

final class TableSolutionPresenter: TableSolutionPresentationLogic {
    weak var viewController: TableSolutionDisplayLogic?
}

// MARK: - TableSolutionPresentationLogic

extension TableSolutionPresenter {
    func presentSolution(_ response: TableSolutionDataFlow.Response) {
        var items: [TableSolutionSectionItem] = [
            .init(text: "X", kind: .header),
            .init(text: "Y", kind: .header),
            .init(text: "Z", kind: .header)
        ]
        
        for (idx, step) in response.solution.steps.enumerated() {
            let isLastStep = idx == response.solution.steps.count - 1
            let isSolvedByX = isLastStep && response.solution.xContainsTargetVolume
            let isSolvedByY = isLastStep && response.solution.yContainsTargetVolume
            
            items.append(contentsOf: [
                .init(text: "\(step.xFilledVolume)", kind: .filledVolume(isSolution: isSolvedByX)),
                .init(text: "\(step.yFilledVolume)", kind: .filledVolume(isSolution: isSolvedByY)),
                .init(text: format(stepAction: step.action), kind: .explanation)
            ])
        }
        
        let sections = [TableSolutionSection(items: items)]
        viewController?.showSolution(.init(sections: sections))
    }
}

// MARK: - Helpers

private extension TableSolutionPresenter {
    func format(stepAction: SolutionStep.Action) -> String {
        switch stepAction {
        case .empty(let bucket):
            return L10n.Screen.Solution.Table.StepAction.empty(bucket.rawValue.uppercased())
        case .fill(let bucket):
            return L10n.Screen.Solution.Table.StepAction.fill(bucket.rawValue.uppercased())
        case .transfer(let direction):
            switch direction {
            case .fromXToY:
                return L10n.Screen.Solution.Table.StepAction.transfer("X", "Y")
            case .fromYToX:
                return L10n.Screen.Solution.Table.StepAction.transfer("Y", "X")
            }
        }
    }
}
