//
//  ArrowView.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 10.03.2022.
//

import UIKit

struct ArrowViewModel {
    let direction: Direction
    let backgroundColor: UIColor
    
    enum Direction {
        case leadingToTrailing
        case trailingToLeading
    }
}

final class ArrowView: UIView {
    // MARK: - Types
    
    enum Orientation {
        case vertical, horizontal
    }
    
    // MARK: - Constants
    
    private enum Constants {
        static let arrowHeadLength: CGFloat = 20
        static let arrowHeadWidth: CGFloat = 20
        static let arrowLength: CGFloat = 40
        static let arrowBodyWidth: CGFloat = 10
        
        static let fillColor = UIColor.systemGreen
        static let emptyColor = UIColor.systemRed
        static let transferColor = UIColor.systemBlue
        static let headToBodyRatio = 0.3
    }
    
    // MARK: - Properties
    
    private let orientation: Orientation
    private var viewModel: ArrowViewModel?
    
    // MARK: - Lifecycle
    
    init(orientation: Orientation, frame: CGRect = .zero) {
        self.orientation = orientation
        super.init(frame: frame)
        isOpaque = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration

    func configure(with viewModel: ArrowViewModel) {
        self.viewModel = viewModel
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let viewModel = viewModel else { return }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let translation: CGPoint
        let rotation: CGFloat
        
        switch orientation {
        case .vertical:
            switch viewModel.direction {
            case .trailingToLeading:
                translation = .zero
                rotation = 0
            case .leadingToTrailing:
                translation = CGPoint(x: rect.width, y: rect.height)
                rotation = .pi
            }
        case .horizontal:
            switch viewModel.direction {
            case .trailingToLeading:
                translation = CGPoint(x: 0, y: rect.height)
                rotation = -.pi / 2
            case .leadingToTrailing:
                translation = CGPoint(x: rect.width, y: 0)
                rotation = .pi / 2
            }
        }
        
        context.clear(rect)
        context.translateBy(x: translation.x, y: translation.y)
        context.rotate(by: rotation)
        context.setFillColor(viewModel.backgroundColor.cgColor)
                
        context.move(to: .init(x: Constants.arrowHeadWidth / 2, y: 0))
        context.addLine(to: .init(x: Constants.arrowHeadWidth, y: Constants.arrowHeadLength))
        context.addLine(
            to: .init(
                x: Constants.arrowHeadWidth - (Constants.arrowHeadWidth - Constants.arrowBodyWidth) / 2,
                y: Constants.arrowHeadLength
            )
        )
        context.addLine(
            to: .init(
                x: Constants.arrowHeadWidth - (Constants.arrowHeadWidth - Constants.arrowBodyWidth) / 2,
                y: Constants.arrowLength
            )
        )
        context.addLine(
            to: .init(
                x: (Constants.arrowHeadWidth - Constants.arrowBodyWidth) / 2,
                y: Constants.arrowLength
            )
        )
        context.addLine(
            to: .init(
                x: (Constants.arrowHeadWidth - Constants.arrowBodyWidth) / 2,
                y: Constants.arrowHeadLength
            )
        )
        context.addLine(to: .init(x: 0, y: Constants.arrowHeadLength))
        context.closePath()
        context.fillPath()
    }
    
    override var intrinsicContentSize: CGSize {
        switch orientation {
        case .vertical:
            return CGSize(width: Constants.arrowHeadWidth, height: Constants.arrowLength)
        case .horizontal:
            return CGSize(width: Constants.arrowLength, height: Constants.arrowHeadWidth)
        }
    }
    
    // MARK: - Animation
    
    func flicker(with duration: TimeInterval) {
        UIView.animate(
            withDuration: duration / 3,
            animations: {
                self.alpha = 1
            },
            completion: { [weak self] _ in
                UIView.animate(
                    withDuration: duration / 3,
                    delay: duration / 3,
                    animations: {
                        self?.alpha = 0
                    }
                )
            }
        )
    }
}
