//
//  ViewController.swift
//  Demo
//
//  Created by Jawad Ali on 06/10/2021.
//

import UIKit
import JDAnimatedField
class ViewController: UIViewController {

  private lazy var fieldCenter: JDAnimatedTextField = {
    let field = JDAnimatedTextField()
    field.translatesAutoresizingMaskIntoConstraints = false
    field.placeholder = "search"
    field.textFieldColor = #colorLiteral(red: 1, green: 0.2591625452, blue: 0.3741788268, alpha: 1)
    field.delegate = self
    field.spellCheckingType = .no
    field.textAlignment = .center
    return field
  }()

  private lazy var fieldRight: JDAnimatedTextField = {
    let field = JDAnimatedTextField()
    field.translatesAutoresizingMaskIntoConstraints = false
    field.placeholder = "Right"
    field.textFieldColor = #colorLiteral(red: 0.3220693469, green: 0.01451195218, blue: 0.5633357763, alpha: 1)
    field.delegate = self
    field.spellCheckingType = .no
    field.textAlignment = .right
    return field
  }()

  private lazy var fieldSmall: JDAnimatedTextField = {
    let field = JDAnimatedTextField()
    field.translatesAutoresizingMaskIntoConstraints = false
    field.placeholder = "Small"
    field.textFieldColor = #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1)
    field.delegate = self
    field.spellCheckingType = .no
    field.textAlignment = .center
    return field
  }()

  private lazy var fieldMid: JDAnimatedTextField = {
    let field = JDAnimatedTextField()
    field.translatesAutoresizingMaskIntoConstraints = false
    field.placeholder = "Medium"
    field.textFieldColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)
    field.delegate = self
    field.spellCheckingType = .no
    field.textAlignment = .left
    return field
  }()

  private lazy var fieldLeft: JDAnimatedTextField = {
    let field = JDAnimatedTextField()
    field.translatesAutoresizingMaskIntoConstraints = false
    field.placeholder = "Left"
    field.textFieldColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    field.delegate = self
    field.spellCheckingType = .no
    field.textAlignment = .left
    return field
  }()

  private lazy var stack: UIStackView = {
    let stack = UIStackView()
    stack.alignment = .center
    stack.axis = .vertical
    stack.spacing = 50
    stack.distribution = .fillEqually
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()



  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupConstraints()
  }
}

extension ViewController: UITextFieldDelegate {
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    if textField == fieldMid {
      fieldMid.showError(with: "Error message here")
    }
    return true
  }
  open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    false
  }
}
private extension ViewController {
  func setupView() {
    [fieldCenter, fieldLeft, fieldRight, fieldSmall, fieldMid].forEach(stack.addArrangedSubview)
    view.addSubview(stack)
  }

  func setupConstraints() {
    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
      stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
      stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
      fieldSmall.widthAnchor.constraint(equalToConstant: 200),
      fieldMid.widthAnchor.constraint(equalToConstant: 260),
      fieldCenter.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
      fieldRight.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
      fieldLeft.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40)
    ])
  }
}
