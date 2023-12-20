//
//  UnderlineTextFieldView.swift
//  CourseHandicapCalculator
//
//  Created by Izzatilla on 20.12.2023.
//

import UIKit
import SnapKit

final class UnderlineTextFieldView: UIView {
    
    var text: String {
        set {
            textField.text = newValue
        }
        get {
            (textField.text ?? "").replacingOccurrences(of: ",", with: ".")
        }
    }
    var placeHolder: String = "" {
        didSet {
            placeholderLabel.text = placeHolder
        }
    }
    var keyboardType: UIKeyboardType = .decimalPad {
        didSet {
            textField.keyboardType = keyboardType
        }
    }
    private let textField = UITextField().apply {
        $0.keyboardType = .decimalPad
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.textAlignment = .right
    }
    private let placeholderLabel = UILabel().apply {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .placeholderText
    }
    private let underlineView = UIView().apply {
        $0.backgroundColor = .separator
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupUI()
        configureUI()
        addActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }
}

//MARK: -UI

private extension UnderlineTextFieldView {
    func setupUI() {
        [placeholderLabel, textField, underlineView].forEach(addSubview)
        
        makeConstraints()
    }
    
    func makeConstraints() {
        snp.makeConstraints {
            $0.height.equalTo(40)
        }
        textField.snp.makeConstraints {
            $0.right.verticalEdges.equalToSuperview()
            $0.width.equalTo(150)
        }
        placeholderLabel.snp.makeConstraints {
            $0.left.verticalEdges.equalToSuperview()
            $0.left.equalTo(textField.snp.right)
        }
        underlineView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func configureUI() {
        
    }
}

//MARK: -Actions

private extension UnderlineTextFieldView {
    func addActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        becomeFirstResponder()
    }
}
