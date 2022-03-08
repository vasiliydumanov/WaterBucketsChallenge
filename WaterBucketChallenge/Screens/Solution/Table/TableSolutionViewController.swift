//
//  TableSolutionViewController.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 04.03.2022.
//

import UIKit

protocol TableSolutionDisplayLogic: AnyObject {
    func showSolution(_ viewModel: TableSolutionDataFlow.ViewModel)
}

final class TableSolutionViewController: UIViewController, TableSolutionDisplayLogic {
    // MARK: - Constants
    
    private enum Constants {
        static let headerFontSize: CGFloat = 20.0
        static let fontSize: CGFloat = 17.0
    }
    
    // MARK: - State
    
    private let state = State(); private final class State {
        var displayedSections: [TableSolutionSection] = []
    }
    
    // MARK: - Subviews
    
    private lazy var solutionCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeSolutionCollectionLayout())
        collectionView.dataSource = self
        collectionView.register(TableSolutionItemCell.self, forCellWithReuseIdentifier: TableSolutionItemCell.reuseID)
        return collectionView
    }()
    
    // MARK: - Properties
    
    private let interactor: TableSolutionBusinessLogic
    
    // MARK: - Lifecycle
    
    init(interactor: TableSolutionBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        makeLayout()
        interactor.requestSolution()
    }
    
    // MARK: - TableSolutionDisplayLogic
    
    func showSolution(_ viewModel: TableSolutionDataFlow.ViewModel) {
        state.displayedSections = viewModel.sections
        solutionCollectionView.reloadData()
    }
}

// MARK: - Helpers

private extension TableSolutionViewController {
    func addSubviews() {
        view.addSubview(solutionCollectionView)
    }
    
    func makeLayout() {
        solutionCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func makeSolutionCollectionLayout() -> UICollectionViewCompositionalLayout {
        let filledVolumeItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.2),
            heightDimension: .estimated(60)
        )
        let filledVolumeItem = NSCollectionLayoutItem(layoutSize: filledVolumeItemSize)
        
        let explanationItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.6),
            heightDimension: .estimated(60)
        )
        let explanationItem = NSCollectionLayoutItem(layoutSize: explanationItemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(60)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [filledVolumeItem, filledVolumeItem, explanationItem]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

// MARK: - UICollectionViewDataSource

extension TableSolutionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        state.displayedSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        state.displayedSections[0].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TableSolutionItemCell.reuseID, for: indexPath) as? TableSolutionItemCell
        else { return UICollectionViewCell() }
        
        let item = state.displayedSections[indexPath.section].items[indexPath.row]
        cell.configure(with: makeCellViewModel(for: item))
        return cell
    }
    
    private func makeCellViewModel(for item: TableSolutionSectionItem) -> TableSolutionItemCellViewModel {
        let attributes: [NSAttributedString.Key: Any]
        switch item.kind {
        case .header:
            attributes = [
                .font: UIFont.systemFont(ofSize: Constants.headerFontSize, weight: .bold),
                .foregroundColor: UIColor.label
            ]
        case .filledVolume(let isSolution):
            attributes = [
                .font: UIFont.systemFont(ofSize: Constants.fontSize, weight: .semibold),
                .foregroundColor: isSolution ? UIColor.systemGreen : UIColor.label
            ]
        case .explanation:
            attributes = [
                .font: UIFont.systemFont(ofSize: Constants.fontSize, weight: .regular),
                .foregroundColor: UIColor.label
            ]
        }
        
        let text = NSMutableAttributedString(string: item.text, attributes: attributes)
        return TableSolutionItemCellViewModel(text: text)
    }
}

