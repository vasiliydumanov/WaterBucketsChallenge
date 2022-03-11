//
//  InputsViewController.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 03.03.2022.
//

import SnapKit
import UIKit

protocol InputsDisplayLogic: AnyObject {
    func updateSolveButtonState(_ viewModel: InputsDataFlow.Update.ViewModel)
    func showSolution(_ viewModel: InputsDataFlow.Solve.ViewModel)
}

final class InputsViewController: UIViewController, InputsDisplayLogic {
    // MARK: - Constants
    
    enum Constants {
        static let formStackSpacing: CGFloat = 8
        static let formWidth: CGFloat = 300
        static let formTitleBottomPadding: CGFloat = 20
        static let solveButtonTopPadding: CGFloat = 10
        static let inputLineSpacing: CGFloat = 8
    }
    
    // MARK: - State
    
    private let state = State(); private final class State {
        var rawInputs: RawInputs = .init(x: nil, y: nil, z: nil)
    }
    
    // MARK: - Views
    
    private let formTitleLabel: UILabel = {
        let formTitleLabel = UILabel()
        formTitleLabel.text = L10n.Screen.Inputs.Form.title
        formTitleLabel.font = .preferredFont(forTextStyle: .title2)
        return formTitleLabel
    }()
    
    private let formStack: UIStackView = {
        let formStack = UIStackView()
        formStack.axis = .vertical
        formStack.distribution = .fill
        formStack.spacing = Constants.formStackSpacing
        return formStack
    }()
    
    private let solveButton: UIButton = {
        let solveButton = UIButton(type: .system)
        solveButton.setTitle(L10n.Screen.Inputs.Form.buttonTitle, for: .normal)
        solveButton.addTarget(self, action: #selector(solveButtonTapped), for: .touchUpInside)
        return solveButton
    }()
    
    private var xInputTextField: UITextField!
    private var yInputTextField: UITextField!
    private var zInputTextField: UITextField!
    
    // MARK: - Properties
    
    private let interactor: InputsBusinessLogic
    private let router: InputsRoutingLogic
    
    // MARK: - Lifecycle
    
    init(interactor: InputsBusinessLogic, router: InputsRouter) {
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
        makeLayout()
        notifyInputsUpdated()
    }
}

// MARK: - InputsDisplayLogic

extension InputsViewController {
    func updateSolveButtonState(_ viewModel: InputsDataFlow.Update.ViewModel) {
        solveButton.isEnabled = viewModel.isSolveButtonEnabled
    }
    
    func showSolution(_ viewModel: InputsDataFlow.Solve.ViewModel) {
        switch viewModel {
        case .solved(let solutionWithInputs):
            router.navigate(to: .solution(solutionWithInputs))
        case .notSolvable(let message):
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(.init(title: L10n.Screen.Inputs.Alert.buttonTitle, style: .cancel))
            present(alert, animated: true)
        }
    }
}

// MARK: - Actions

private extension InputsViewController {
    @objc private func notifyInputsUpdated() {
        state.rawInputs = .init(
            x: xInputTextField.text,
            y: yInputTextField.text,
            z: zInputTextField.text
        )
        
        interactor.processUpdatedInputs(state.rawInputs)
    }
    
    @objc private func solveButtonTapped() {
        interactor.solve(.init(rawInputs: state.rawInputs))
    }
}

// MARK: - Private

private extension InputsViewController {
    func addSubviews() {
        view.addSubview(formTitleLabel)
        view.addSubview(formStack)
            
        formStack.addArrangedSubview(makeInputLine(named: "X", storingTextFieldIn: &xInputTextField))
        formStack.addArrangedSubview(makeInputLine(named: "Y", storingTextFieldIn: &yInputTextField))
        formStack.addArrangedSubview(makeInputLine(named: "Z", storingTextFieldIn: &zInputTextField))
        
        view.addSubview(solveButton)
    }
    
    func makeLayout() {
        formTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(formStack)
            make.bottom.equalTo(formStack.snp.top).offset(-Constants.formTitleBottomPadding)
        }
        formStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(Constants.formWidth)
        }
        solveButton.snp.makeConstraints { make in
            make.top.equalTo(formStack.snp.bottom).offset(Constants.solveButtonTopPadding)
            make.centerX.equalTo(formStack)
        }
    }
    
    func makeInputLine(
        named name: String,
        storingTextFieldIn inputTextField: inout UITextField!
    ) -> UIView {
        let inputLineStack = UIStackView()
        inputLineStack.axis = .horizontal
        inputLineStack.spacing = Constants.inputLineSpacing
        
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.setContentHuggingPriority(.required, for: .horizontal)
        inputLineStack.addArrangedSubview(nameLabel)
        
        inputTextField = UITextField()
        inputTextField.keyboardType = .numberPad
        inputTextField.borderStyle = .roundedRect
        inputTextField.addTarget(self, action: #selector(notifyInputsUpdated), for: .editingChanged)
        inputLineStack.addArrangedSubview(inputTextField)
                
        return inputLineStack
    }
}



