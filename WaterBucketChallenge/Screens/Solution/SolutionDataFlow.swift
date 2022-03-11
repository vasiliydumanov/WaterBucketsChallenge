//
//  SolutionDataFlow.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 08.03.2022.
//

enum SolutionDataFlow {
    enum Title {
        struct Response {
            let inputs: Inputs
        }
        
        struct ViewModel {
            let title: String
        }
    }
    
    enum Content {
        struct Response {
            let solutionWithInputs: SolutionWithInputs
        }
        
        struct ViewModel {
            let solutionWithInputs: SolutionWithInputs
            let tabNames: [String]
            let selectedTab: SolutionRoute.Tab
            let selectedTabIndex: Int
        }
    }
    
    enum SelectedTab {
        struct Request {
            let selectedTabIndex: Int
        }
        
        struct Response {
            let solutionWithInputs: SolutionWithInputs
            let selectedTabIndex: Int
        }
        
        struct ViewModel {
            let solutionWithInputs: SolutionWithInputs
            let selectedTab: SolutionRoute.Tab
        }
    }
}
