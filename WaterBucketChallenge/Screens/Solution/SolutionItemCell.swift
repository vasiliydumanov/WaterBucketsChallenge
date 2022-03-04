//
//  SolutionItemCell.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 04.03.2022.
//

import UIKit

struct SolutionItemCellViewModel {
    let text: NSAttributedString
}

final class SolutionItemCell: UICollectionViewCell {
    static let reuseID = "SolutionItemCell"
    
    private enum Constants {
        static let textLabelInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    // MARK: - Views
    
    private let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeLayout()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: SolutionItemCellViewModel) {
        textLabel.attributedText = viewModel.text
    }
}

// MARK: - Setup

private extension SolutionItemCell {
    func addSubviews() {
        contentView.addSubview(textLabel)
    }
    
    func makeLayout() {
        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.textLabelInsets)
        }
    }
}
