//
//  BucketsSolutionView.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 10.03.2022.
//

import UIKit

struct BucketsSolutionViewModel {
    let xVolume: UInt
    let yVolume: UInt
    let state: State
    
    enum State {
        case initial
        case intermediate(step: SolutionStep)
        case final(xBucketState: FinalBucketState, yBucketState: FinalBucketState)
        
        struct FinalBucketState {
            let filledVolume: UInt
            let containsTargetVolume: Bool
        }
    }
}

final class BucketsSolutionView: UIView {
    // MARK: - Constants
    
    private enum Constants {
        static let disabledBucketAlpha: CGFloat = 0.4
        static let bucketContainerSpacing: CGFloat = 12
        // Arrow
        static let arrowHorizontalMargin: CGFloat = 8
        static let arrowFillColor: UIColor = UIColor.systemGreen
        static let arrowEmptyColor: UIColor = UIColor.systemRed
        static let arrowTransferColor: UIColor = UIColor.systemBlue
    }
    
    // MARK: - Views
//    private let bucketsStack: UIStackView = {
//        let bucketsStack = UIStackView()
//        bucketsStack.axis = .horizontal
//        bucketsStack.alignment = .center
//        bucketsStack.spacing = Constants.bucketContainerSpacing
//        return bucketsStack
//    }()
    
    private lazy var xBucketLabel: UILabel = {
        let xBucketLabel = UILabel()
        xBucketLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        xBucketLabel.textAlignment = .center
        return xBucketLabel
    }()
    
    private lazy var yBucketLabel: UILabel = {
        let yBucketLabel = UILabel()
        yBucketLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        yBucketLabel.textAlignment = .center
        return yBucketLabel
    }()
    
    private lazy var xBucketArrow: ArrowView = ArrowView(orientation: .vertical)
    private lazy var yBucketArrow: ArrowView = ArrowView(orientation: .vertical)
    private lazy var transferArrow: ArrowView = ArrowView(orientation: .horizontal)
    
    private lazy var xBucketView: BucketView = BucketView(levelIndicatorSide: .left)
    private lazy var yBucketView: BucketView = BucketView(levelIndicatorSide: .right)
    
    private lazy var xBucketDataContainer: UIView = makeBucketDataContainer(label: xBucketLabel, arrowView: xBucketArrow, bucketView: xBucketView)
    private lazy var yBucketDataContainer: UIView = makeBucketDataContainer(label: yBucketLabel, arrowView: yBucketArrow, bucketView: yBucketView)
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        addSubviews()
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    func configure(with viewModel: BucketsSolutionViewModel, animationDuration: TimeInterval? = nil) {
        let xFilledVolume: UInt
        let yFilledVolume: UInt
        var xIsTargetVolume: Bool = false
        var yIsTargetVolume: Bool = false
        xBucketView.alpha = 1
        yBucketView.alpha = 1
        
        switch viewModel.state {
        case .initial:
            xFilledVolume = 0
            yFilledVolume = 0
        case let .intermediate(step):
            xFilledVolume = step.xFilledVolume
            yFilledVolume = step.yFilledVolume
            
            switch step.action {
            case let .fill(bucket):
                switch bucket {
                case .x:
                    xBucketArrow.configure(with: .init(direction: .leadingToTrailing, backgroundColor: Constants.arrowFillColor))
                    if let animationDuration = animationDuration {
                        xBucketArrow.flicker(with: animationDuration)
                    }
                case .y:
                    yBucketArrow.configure(with: .init(direction: .leadingToTrailing, backgroundColor: Constants.arrowFillColor))
                    if let animationDuration = animationDuration {
                        yBucketArrow.flicker(with: animationDuration)
                    }
                }
            case let .empty(bucket):
                switch bucket {
                case .x:
                    xBucketArrow.configure(with: .init(direction: .trailingToLeading, backgroundColor: Constants.arrowEmptyColor))
                    if let animationDuration = animationDuration {
                        xBucketArrow.flicker(with: animationDuration)
                    }
                case .y:
                    yBucketArrow.configure(with: .init(direction: .trailingToLeading, backgroundColor: Constants.arrowEmptyColor))
                    if let animationDuration = animationDuration {
                        yBucketArrow.flicker(with: animationDuration)
                    }
                }
            case let .transfer(transferDirection):
                let arrowDirection: ArrowViewModel.Direction
                switch transferDirection {
                case .fromXToY:
                    arrowDirection = .leadingToTrailing
                case .fromYToX:
                    arrowDirection = .trailingToLeading
                }
                transferArrow.configure(with: .init(direction: arrowDirection, backgroundColor: Constants.arrowTransferColor))
                if let animationDuration = animationDuration {
                    transferArrow.flicker(with: animationDuration)
                }
            }
            
        case let .final(xBucketState, yBucketState):
            xFilledVolume = xBucketState.filledVolume
            yFilledVolume = yBucketState.filledVolume
            xIsTargetVolume = xBucketState.containsTargetVolume
            yIsTargetVolume = yBucketState.containsTargetVolume
            
            if !xIsTargetVolume {
                xBucketView.alpha = Constants.disabledBucketAlpha
            }
            if !yIsTargetVolume {
                yBucketView.alpha = Constants.disabledBucketAlpha
            }
        }
        
        xBucketLabel.text = "X (\(xFilledVolume)/\(viewModel.xVolume))"
        yBucketLabel.text = "Y (\(yFilledVolume)/\(viewModel.yVolume))"
        
        xBucketView.configure(
            with: .init(
                totalVolume: viewModel.xVolume,
                filledVolume: xFilledVolume,
                isTargetVolume: xIsTargetVolume
            ),
            animationDuration: animationDuration
        )
        yBucketView.configure(
            with: .init(
                totalVolume: viewModel.yVolume,
                filledVolume: yFilledVolume,
                isTargetVolume: yIsTargetVolume
            ),
            animationDuration: animationDuration
        )
    }
}

private extension BucketsSolutionView {
    // MARK: - Setup
    
    func addSubviews() {
        addSubview(xBucketDataContainer)
        addSubview(transferArrow)
        addSubview(yBucketDataContainer)
    }
    
    func makeLayout() {
        xBucketDataContainer.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        transferArrow.setContentCompressionResistancePriority(.required, for: .horizontal)
        transferArrow.setContentHuggingPriority(.required, for: .horizontal)
        transferArrow.snp.makeConstraints { make in
            make.centerY.equalTo(xBucketView)
            make.leading.equalTo(xBucketDataContainer.snp.trailing).offset(Constants.arrowHorizontalMargin)
        }
        yBucketDataContainer.snp.makeConstraints { make in
            make.leading.equalTo(transferArrow.snp.trailing).offset(Constants.arrowHorizontalMargin)
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalTo(xBucketDataContainer)
        }
    }
    
    func makeBucketDataContainer(label: UILabel, arrowView: ArrowView, bucketView: BucketView) -> UIView {
        let container = UIView()
        
        container.addSubview(label)
        container.addSubview(arrowView)
        container.addSubview(bucketView)
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalTo(bucketView.bucketCenterX)
        }
        arrowView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(Constants.bucketContainerSpacing)
            make.centerX.equalTo(bucketView.bucketCenterX)
        }
        bucketView.snp.makeConstraints { make in
            make.top.equalTo(arrowView.snp.bottom).offset(Constants.bucketContainerSpacing)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        return container
    }
}
