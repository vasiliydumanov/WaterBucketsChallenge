//
//  SolutionDataFlow.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 08.03.2022.
//

enum SolutionDataFlow {
    enum Content {
        struct Response {
            let solution: Solution
        }
        
        struct ViewModel {
            let solution: Solution
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
            let solution: Solution
            let selectedTabIndex: Int
        }
        
        struct ViewModel {
            let solution: Solution
            let selectedTab: SolutionRoute.Tab
        }
    }
}
