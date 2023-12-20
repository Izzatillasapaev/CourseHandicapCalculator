//
//  CalculatorViewController.swift
//  CourseHandicapCalculator
//
//  Created by Izzatilla on 20.12.2023.
//

import UIKit
import SnapKit

final class CalculatorViewController: UIViewController {

    private let titleTextLabel = UILabel().apply {
        $0.text = "Calculate Course Handicap Under WHS"
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.textAlignment = .center
    }
    private let handicapIndexTextField = UnderlineTextFieldView().apply {
        $0.placeHolder = "Handicap Index"
    }
    private let slopeRatingTextField = UnderlineTextFieldView().apply {
        $0.placeHolder = "Slope Rating"
    }
    private let coureRatingTextField = UnderlineTextFieldView().apply {
        $0.placeHolder = "Course Rating"
        $0.keyboardType = .numberPad
    }
    private let parTextField = UnderlineTextFieldView().apply {
        $0.placeHolder = "Par"
        $0.keyboardType = .numberPad
    }
    private let textFieldsStackView = UIStackView().apply {
        $0.axis = .vertical
        $0.spacing = 20
    }
    private let calculateButton = UIButton().apply {
        $0.setTitle("Calculate", for: .normal)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .tintColor
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
    }
    private let resultLabel = UILabel().apply {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textAlignment = .center
    }
    
    private var bag = Bag()
    private let viewModel: CalculatorViewModel
    
    init(viewModel: CalculatorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureUI()
        addActions()
        setupObservers()
    }
    
    private func setupObservers() {
        bindViewModel(viewModel) { [weak self] event in
            guard let self else { return }
            switch event {
            case .showError(let error):
                showError(error: error)
            case .showResult(let result):
                showResult(result: result)
            }
        }.store(in: &bag)
    }
}

//MARK: -UI

private extension CalculatorViewController {
    func setupUI() {
        
        [titleTextLabel,
         handicapIndexTextField,
         slopeRatingTextField,
         coureRatingTextField,
         parTextField].forEach(textFieldsStackView.addArrangedSubview)
        
        [textFieldsStackView,
         calculateButton,
         resultLabel].forEach(view.addSubview)
        
        makeConstraints()
    }
    
    func makeConstraints() {
        textFieldsStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(25)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        calculateButton.snp.makeConstraints {
            $0.top.equalTo(textFieldsStackView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
            $0.width.equalTo(200)
        }
        
        resultLabel.snp.makeConstraints {
            $0.top.equalTo(calculateButton.snp.bottom).offset(25)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
    }
    
    func configureUI() {
        view.backgroundColor = .white
        handicapIndexTextField.becomeFirstResponder()
    }
    
    func showError(error: String) {
        resultLabel.textColor = .red
        resultLabel.text = error
    }
    
    func showResult(result: Int) {
        resultLabel.textColor = .black
        resultLabel.text = "Your Course Handicap is: \(result)"
    }
}

//MARK: -Actions

private extension CalculatorViewController {
    func addActions() {
        calculateButton.addTarget(self, action: #selector(calculatePressed), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnView(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTapOnView(_ sender: UITapGestureRecognizer? = nil) {
        resignFirstResponder()
    }
    
    @objc func calculatePressed() {
        let params = CourseHandicapParamsModel(
            handicapIndex: handicapIndexTextField.text,
            slopeRating: slopeRatingTextField.text,
            coureRating: coureRatingTextField.text,
            par: parTextField.text)
        
        viewModel.sendAction(.calculate(params: params))
    }
}
