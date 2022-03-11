//
//  SolutionViewController.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 08.03.2022.
//

import UIKit

protocol SolutionDisplayLogic: AnyObject {
    func showTitle(_ viewModel: SolutionDataFlow.Title.ViewModel)
    func showContent(_ viewModel: SolutionDataFlow.Content.ViewModel)
    func showSelectedTab(_ viewModel: SolutionDataFlow.SelectedTab.ViewModel)
}

final class SolutionViewController: UIViewController, SolutionDisplayLogic {
    // MARK: - Constants
    
    private enum Constants {
        static let contentInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let contentSpacing: CGFloat = 16
    }
    
    // MARK: - Properties
    
    private let interactor: SolutionBusinessLogic
    private let router: SolutionRoutingLogic
    
    // MARK: - Views
    
    private lazy var contentStack: UIStackView = {
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.distribution = .fill
        contentStack.spacing = Constants.contentSpacing
        return contentStack
    }()
    
    private lazy var tabsView: UISegmentedControl = {
        let tabsView = UISegmentedControl()
        return tabsView
    }()
    
    private lazy var tabsContainer = UIView()
    
    // MARK: - Lifecycle
    
    init(interactor: SolutionBusinessLogic, router: SolutionRoutingLogic) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        makeConstraints()
        interactor.requestTitle()
        interactor.requestContent()
    }
    
    // MARK: - SolutionDisplayLogic
    
    func showTitle(_ viewModel: SolutionDataFlow.Title.ViewModel) {
        title = viewModel.title
    }
    
    func showContent(_ viewModel: SolutionDataFlow.Content.ViewModel) {
        tabsView.removeAllSegments()
        for (idx, tabName) in viewModel.tabNames.enumerated() {
            tabsView.insertSegment(
                action: UIAction(
                    title: tabName,
                    handler: { [weak self] _ in self?.didSelectTab(at: idx) }
                ),
                at: idx,
                animated: false
            )
        }
        tabsView.selectedSegmentIndex = viewModel.selectedTabIndex
        router.navigate(
            to: .tab(
                viewModel.selectedTab,
                solutionWithInputs: viewModel.solutionWithInputs,
                tabsContainer: tabsContainer
            )
        )
    }
    
    func showSelectedTab(_ viewModel: SolutionDataFlow.SelectedTab.ViewModel) {
        router.navigate(
            to: .tab(
                viewModel.selectedTab,
                solutionWithInputs: viewModel.solutionWithInputs,
                tabsContainer: tabsContainer
            )
        )
    }
}

private extension SolutionViewController {
    // MARK: - Setup
    
    private func addSubviews() {
        view.addSubview(tabsView)
        view.addSubview(tabsContainer)
    }
    
    private func makeConstraints() {
        tabsView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        tabsContainer.snp.makeConstraints { make in
            make.top.equalTo(tabsView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    
    func didSelectTab(at tabIndex: Int) {
        interactor.requestSelectedTab(.init(selectedTabIndex: tabIndex))
    }
}
