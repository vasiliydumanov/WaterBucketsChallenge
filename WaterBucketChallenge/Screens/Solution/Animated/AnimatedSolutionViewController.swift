//
//  AnimatedSolutionViewController.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 08.03.2022.
//

import UIKit

protocol AnimatedSolutionDisplayLogic: AnyObject {
    func showBuckets(_ viewModel: AnimatedSolutionDataFlow.Buckets.ViewModel)
}

final class AnimatedSolutionViewController: UIViewController, AnimatedSolutionDisplayLogic {
    // MARK: - Constants
    
    private enum Constants {
        static let bucketsAnimationDuration: TimeInterval = 1
        static let bucketsStateUpdateInterval: TimeInterval = 1.5
    }
    
    // MARK: - State
    
    private let state = State(); private final class State {
        var solutionPosition: AnimatedSolutionDataFlow.Buckets.ViewModel.SolutionPosition = .initial
    }
    
    // MARK: - Properties
    
    private let interactor: AnimatedSolutionBusinessLogic
    private var animationTimer: DispatchSourceTimer?
    
    // MARK: - Views
    
    private lazy var bucketsSolutionView = BucketsSolutionView()
    private lazy var playbackControlButton: UIButton = {
        let playbackControlButton = UIButton(type: .system)
        playbackControlButton.addTarget(self, action: #selector(playbackControlButtonTapped), for: .touchUpInside)
        return playbackControlButton
    }()
    
    // MARK: - Lifecycle
    
    init(interactor: AnimatedSolutionBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        makeConstraints()
        interactor.requestBucketsNextState()
    }
    
    // MARK: - AnimatedSolutionDisplayLogic
    
    func showBuckets(_ viewModel: AnimatedSolutionDataFlow.Buckets.ViewModel) {
        bucketsSolutionView.configure(
            with: viewModel.buckets,
            animationDuration: viewModel.solutionPosition != .initial ? Constants.bucketsAnimationDuration : nil
        )
        
        let playbackControlButtonTitle: String
                
        switch viewModel.solutionPosition {
        case .initial:
            playbackControlButtonTitle = L10n.Screen.Solution.Animated.startAnimation
        case .intermediate:
            playbackControlButtonTitle = L10n.Screen.Solution.Animated.resetAnimation
        case .final:
            playbackControlButtonTitle = L10n.Screen.Solution.Animated.resetAnimation
            stopAnimation()
        }
        
        playbackControlButton.setTitle(playbackControlButtonTitle, for: .normal)
        state.solutionPosition = viewModel.solutionPosition
    }
}

private extension AnimatedSolutionViewController {
    // MARK: - Setup
    
    func addSubviews() {
        view.addSubview(bucketsSolutionView)
        view.addSubview(playbackControlButton)
    }
    
    func makeConstraints() {
        bucketsSolutionView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(300)
        }
        playbackControlButton.snp.makeConstraints { make in
            make.centerX.equalTo(bucketsSolutionView)
            make.top.equalTo(bucketsSolutionView.snp.bottom).offset(20)
        }
    }
    
    // MARK: - Animation
    
    @objc private func playbackControlButtonTapped() {
        switch state.solutionPosition {
        case .initial:
            startAnimation()
        case .intermediate, .final:
            resetAnimation()
        }
    }
    
    private func startAnimation() {
        animationTimer = DispatchSource.makeTimerSource(flags: .strict, queue: .main)
        animationTimer?.schedule(
            deadline: .now(),
            repeating: Constants.bucketsStateUpdateInterval
        )
        animationTimer?.setEventHandler { [weak self] in
            self?.interactor.requestBucketsNextState()
        }
        animationTimer?.resume()
    }
    
    private func stopAnimation() {
        animationTimer?.cancel()
        animationTimer = nil
    }
    
    private func resetAnimation() {
        stopAnimation()
        interactor.requestResetBuckets()
    }
}
