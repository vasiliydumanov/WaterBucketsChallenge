//
//  BucketView.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 09.03.2022.
//

import UIKit
import SnapKit

struct BucketViewModel {
    let totalVolume: UInt
    let filledVolume: UInt
    let isTargetVolume: Bool
}

final class BucketView: UIView {
    // MARK: - Types
    
    enum LevelIndicatorSide {
        case left, right
    }
    
    // MARK: - Constants
    
    private enum Constants {
        // Hull
        static let hullCornerRadius: CGFloat = 16
        static let hullThickness: CGFloat = 4
        static let hullColor: UIColor = .systemGray3
        // Level Indicator
        static let levelIndicatorSize: CGSize = CGSize(width: 12, height: 12)
        static let levelIndicatorToHullSpacing: CGFloat = 2
        static let levelIndicatorColor: UIColor = .systemGray
        // Water
        static let waterToHullSpacing: CGFloat = 2
        static let waterToBucketBrimSpacing: CGFloat = 2
        static let waterSurfaceCornerRadius: CGFloat = 4
        static let waterTopColor: UIColor = .systemBlue
        static let waterBottomColor: UIColor = UIColor.systemBlue.withAlphaComponent(0.7)
        static let targetVolumeTopColor: UIColor = .systemGreen
        static let targetVolumeBottomColor: UIColor = UIColor.systemGreen.withAlphaComponent(0.7)
    }
    
    // MARK: - Layout Guides
    
    private(set) lazy var bucketCenterX: UILayoutGuide = {
        let bucketCenterX = UILayoutGuide()
        addLayoutGuide(bucketCenterX)
        return bucketCenterX
    }()
    
    // MARK: - Properties
    
    private let levelIndicatorSide: LevelIndicatorSide
    private var viewModel: BucketViewModel?

    // MARK: - Layers
    
    private let waterMaskLayer: CALayer = {
        let waterMaskLayer = CALayer()
        waterMaskLayer.backgroundColor = UIColor.white.cgColor
        waterMaskLayer.cornerRadius = Constants.waterSurfaceCornerRadius
        waterMaskLayer.cornerCurve = .continuous
        waterMaskLayer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return waterMaskLayer
    }()
    
    private lazy var waterLayer: CAGradientLayer = {
        let waterLayer = CAGradientLayer()
        waterLayer.cornerRadius = Constants.hullCornerRadius - Constants.hullThickness / 2 - Constants.waterToHullSpacing
        waterLayer.cornerCurve = .continuous
        waterLayer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        waterLayer.mask = self.waterMaskLayer
        return waterLayer
    }()
    
    private let levelIndicatorLayer: CAShapeLayer = {
        let levelIndicatorLayer = CAShapeLayer()
        levelIndicatorLayer.fillColor = Constants.levelIndicatorColor.cgColor
        levelIndicatorLayer.lineJoin = .round
        return levelIndicatorLayer
    }()
    
    // MARK: - Lifecycle
    
    init(
        levelIndicatorSide: LevelIndicatorSide,
        frame: CGRect = .zero
    ) {
        self.levelIndicatorSide = levelIndicatorSide
        super.init(frame: frame)
        isOpaque = false
        addSublayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutWaterLayer()
        layoutLevelIndicatorLayer()
        layoutCenterXGuide()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.clear(rect)
        drawHull(in: rect, using: context)
    }
        
    // MARK: - Updating value
    
    func configure(with viewModel: BucketViewModel, animationDuration: TimeInterval? = nil) {
        self.viewModel = viewModel
        if let animationDuration = animationDuration {
            CATransaction.begin()
            CATransaction.setAnimationDuration(animationDuration)
        }
        layoutWaterLayer()
        layoutLevelIndicatorLayer()
        if animationDuration != nil {
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.init(name: .easeInEaseOut))
            CATransaction.commit()
        }
    }
}

private extension BucketView {
    // MARK: - Drawing
    
    func addSublayers() {
        layer.addSublayer(waterLayer)
        layer.addSublayer(levelIndicatorLayer)
    }
    
    var hullXOffset: CGFloat {
        switch levelIndicatorSide {
        case .left:
            return Constants.levelIndicatorSize.width + Constants.levelIndicatorToHullSpacing
        case .right:
            return 0
        }
    }
    
    func drawHull(in rect: CGRect, using context: CGContext) {
        context.setStrokeColor(Constants.hullColor.cgColor)
        context.setLineWidth(Constants.hullThickness)
        context.setLineCap(.round)
        context.translateBy(
            x: hullXOffset + Constants.hullThickness / 2,
            y: Constants.hullThickness / 2
        )
        
        let hullWidth = rect.width - Constants.levelIndicatorSize.width - Constants.levelIndicatorToHullSpacing - Constants.hullThickness
        let hullHeight = rect.height - Constants.hullThickness
                
        context.move(to: .zero)
        context.addLine(
            to: CGPoint(
                x: 0,
                y: hullHeight - Constants.hullCornerRadius
            )
        )
        context.addArc(
            center: CGPoint(
                x: Constants.hullCornerRadius,
                y: hullHeight - Constants.hullCornerRadius
            ),
            radius: Constants.hullCornerRadius,
            startAngle: .pi, endAngle: .pi / 2,
            clockwise: true
        )
        context.addLine(
            to: CGPoint(
                x: hullWidth - Constants.hullCornerRadius,
                y: hullHeight
            )
        )
        context.addArc(
            center: CGPoint(
                x: hullWidth - Constants.hullCornerRadius,
                y: hullHeight - Constants.hullCornerRadius
            ),
            radius: Constants.hullCornerRadius,
            startAngle: .pi / 2, endAngle: 0,
            clockwise: true
        )
        context.addLine(to: CGPoint(x: hullWidth, y: 0))
        context.strokePath()
    }
    
    // MARK: - Layout
    
    func calculateWaterHeights() -> (max: CGFloat, current: CGFloat) {
        let maxWaterHeight: CGFloat = bounds.height - Constants.hullThickness - Constants.waterToHullSpacing - Constants.waterToBucketBrimSpacing
        
        let waterHeight: CGFloat = {
            guard let viewModel = viewModel else { return 0 }
            return maxWaterHeight * CGFloat(viewModel.filledVolume) / CGFloat(viewModel.totalVolume)
        }()
        return (maxWaterHeight, waterHeight)
    }
    
    func layoutWaterLayer() {
        if let viewModel = viewModel {
            waterLayer.colors = viewModel.isTargetVolume
                ? [Constants.targetVolumeTopColor.cgColor, Constants.targetVolumeBottomColor.cgColor]
                : [Constants.waterTopColor.cgColor, Constants.waterBottomColor.cgColor]
        }
        
        let waterWidth = bounds.width - 2 * Constants.hullThickness - 2 * Constants.waterToHullSpacing - Constants.levelIndicatorSize.width - Constants.levelIndicatorToHullSpacing
        let waterHeights = calculateWaterHeights()
        
        let waterRect = CGRect(
            x: hullXOffset + Constants.hullThickness + Constants.waterToHullSpacing,
            y: Constants.waterToBucketBrimSpacing,
            width: waterWidth,
            height: waterHeights.max
        )
        
        let waterMaskRect = CGRect(
            x: 0,
            y: waterHeights.max - waterHeights.current,
            width: waterWidth,
            height: waterHeights.current
        )
        
        waterLayer.frame = waterRect
        waterMaskLayer.frame = waterMaskRect
    }
    
    func layoutLevelIndicatorLayer() {
        let levelIndicatorOriginX: CGFloat
        let levelIndicatorScaleX: CGFloat
        
        switch levelIndicatorSide {
        case .left:
            levelIndicatorOriginX = 0
            levelIndicatorScaleX = -1
        case .right:
            levelIndicatorOriginX = bounds.width - Constants.levelIndicatorSize.width
            levelIndicatorScaleX = 1
        }
        
        let waterHeights = calculateWaterHeights()
        let levelIndicatorRect = CGRect(
            origin: .init(
                x: levelIndicatorOriginX,
                y: Constants.waterToBucketBrimSpacing + waterHeights.max - waterHeights.current - Constants.levelIndicatorSize.height / 2
            ),
            size: Constants.levelIndicatorSize
        )
        levelIndicatorLayer.frame = levelIndicatorRect
        
        let levelIndicatorPath = UIBezierPath()
        levelIndicatorPath.move(
            to: CGPoint(
                x: 0,
                y: Constants.levelIndicatorSize.height / 2
            )
        )
        levelIndicatorPath.addLine(
            to: CGPoint(
                x: Constants.levelIndicatorSize.width,
                y: Constants.levelIndicatorSize.height
            )
        )
        levelIndicatorPath.addLine(
            to: CGPoint(
                x: Constants.levelIndicatorSize.width,
                y: 0
            )
        )
        levelIndicatorPath.close()
        
        levelIndicatorLayer.path = levelIndicatorPath.cgPath
        levelIndicatorLayer.transform = CATransform3DMakeScale(levelIndicatorScaleX, 1, 1)
    }
    
    func layoutCenterXGuide() {
        let centerX: CGFloat = {
            switch levelIndicatorSide {
            case .left:
                return hullXOffset + (bounds.width - hullXOffset) / 2
            case .right:
                return (bounds.width - hullXOffset) / 2
            }
        }()
        
        bucketCenterX.snp.remakeConstraints { make in
            make.left.equalTo(centerX)
        }
    }
}
