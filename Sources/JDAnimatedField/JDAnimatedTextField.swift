
import UIKit
@IBDesignable
open class JDAnimatedTextField: UITextField {
  private lazy var shapeLayerRight = CAShapeLayerFactory.createShapeLayer()
  private lazy var shapeLayerLeft = CAShapeLayerFactory.createShapeLayer()
  private lazy var shapeLayer = CAShapeLayerFactory.createShapeLayer()

  private lazy var floatingLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.boldSystemFont(ofSize: 24)
    return label
  }()

  private lazy var errorLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .red
    return label
  }()

  open override var textAlignment: NSTextAlignment {
    didSet {
      floatingLabel.textAlignment = textAlignment
    }
  }

  private var heightErrorLabelConstraint: NSLayoutConstraint!
  private var topErrorLabelConstraint: NSLayoutConstraint!

  private let speed: Double = 0.5
  private let offset: CGFloat = 30
  private var completedFlow = false
  private lazy var cursorPosition = bounds.midX

  @IBInspectable dynamic open var lineWidth: CGFloat = 4 { didSet { layoutIfNeeded() } }
  @IBInspectable dynamic open var textFieldColor: UIColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) { didSet { layoutIfNeeded() } }
  @IBInspectable dynamic open var placeHolderFont: UIFont = UIFont.boldSystemFont(ofSize: 20) { didSet { layoutIfNeeded() } }
  @IBInspectable dynamic open var errorLabelFont: UIFont = UIFont.boldSystemFont(ofSize: 14) { didSet { layoutIfNeeded() } }
  @IBInspectable dynamic open var errorLabelColor: UIColor = .red { didSet { layoutIfNeeded() } }

  open override var placeholder: String? {
    didSet {
      if placeholder != nil {
        setFloatingLabelText()
      }
    }
  }

  //MARK:- init

  public override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required public init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  public override var intrinsicContentSize: CGSize {
     CGSize(width: super.intrinsicContentSize.width, height: 70)
  }

  open override func caretRect(for position: UITextPosition) -> CGRect {
    let rect = super.caretRect(for: position)
    return completedFlow ?  CGRect(x: rect.origin.x - lineWidth/2, y: rect.origin.y-10, width: lineWidth*1.5, height: rect.height+20) : .zero
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    setColors()
    setFonts()
    setLineWidth()
    updatePaths(midPoint: cursorPosition)
  }
}
private extension JDAnimatedTextField {
  func setColors() {
    floatingLabel.textColor = textFieldColor
    [shapeLayerRight, shapeLayerLeft, shapeLayer].forEach { $0.strokeColor = textFieldColor.cgColor }
    tintColor = textFieldColor
    textColor = textFieldColor
    errorLabel.textColor = errorLabelColor
  }

  func setFonts() {
    floatingLabel.font = placeHolderFont
    errorLabel.font = errorLabelFont
  }

  func commonInit() {
    self.borderStyle = .none
    setFloatingLabelText()
    setupView()
    addConstraints()
    shapeLayer.lineCap = .round
    self.addTarget(self, action: #selector(becomeResponder), for: .editingDidBegin)
    self.addTarget(self, action: #selector(resignResponder), for: .editingDidEnd)
    self.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    self.addTarget(self, action: #selector(allEvents), for: .allTouchEvents)
  }

  func setupView() {

    [shapeLayerRight, shapeLayerLeft, shapeLayer].forEach(layer.addSublayer)
    addSubview(floatingLabel)
    addSubview(errorLabel)
  }

  func addConstraints() {
    topErrorLabelConstraint = errorLabel.topAnchor.constraint(equalTo: topAnchor)
    heightErrorLabelConstraint = errorLabel.heightAnchor.constraint(equalToConstant: 0)

    NSLayoutConstraint.activate ( [
      floatingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset),
      floatingLabel.topAnchor.constraint(equalTo: topAnchor),
      floatingLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
      floatingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset),
      errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset),
      errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset),
      topErrorLabelConstraint,
      heightErrorLabelConstraint
    ])
  }

  func updatePaths(midPoint: CGFloat) {
    topErrorLabelConstraint.constant = bounds.maxY
    let halfLineWidth = lineWidth/2

    let midX = midPoint
    let upperCenter = CGPoint(x: midX, y: bounds.minY + halfLineWidth)
    let lowerCenter = CGPoint(x: midX, y: bounds.maxY - halfLineWidth)

    let bezierPath = UIBezierPath()
    bezierPath.move(to: upperCenter)
    bezierPath.addLine(to: CGPoint(x: upperCenter.x, y: bounds.maxY-bounds.maxY/3))

    shapeLayer.path = bezierPath.cgPath
    shapeLayer.strokeEnd = 0
    let bezierPathLeft = UIBezierPath()

    bezierPathLeft.move(to: upperCenter)
    bezierPathLeft.addLine(to: CGPoint(x: offset, y: bounds.minY + halfLineWidth))
    bezierPathLeft.addArc(withCenter: CGPoint(x: offset + halfLineWidth*2, y: bounds.midY), radius: bounds.midY - halfLineWidth, startAngle: 270.deg2rad, endAngle: 90.deg2rad, clockwise: false)
    bezierPathLeft.addLine(to: lowerCenter)


    let bezierPathRight = UIBezierPath()

    bezierPathRight.move(to: upperCenter)
    bezierPathRight.addLine(to: CGPoint(x: bounds.maxX - offset, y: bounds.minY + halfLineWidth))
    bezierPathRight.addArc(withCenter: CGPoint(x: bounds.maxX - offset - halfLineWidth*2, y: bounds.midY), radius: bounds.midY - halfLineWidth, startAngle: 270.deg2rad, endAngle: 90.deg2rad, clockwise: true)
    bezierPathRight.addLine(to: lowerCenter)

    shapeLayerLeft.path = bezierPathRight.cgPath
    shapeLayerRight.path = bezierPathLeft.cgPath

  }

  func setLineWidth() {
    [shapeLayerRight, shapeLayerLeft, shapeLayer].forEach { $0.lineWidth = lineWidth }
  }

  func setFloatingLabelText() {
    floatingLabel.text = placeholder?.uppercased()
    placeholder = nil
  }

}
// MARK: - Actions on textfield responder and resign
private extension JDAnimatedTextField {
  @objc func becomeResponder() {
    if let text = text, text.isEmpty {
      UIView.animate(withDuration: speed) {
        self.floatingLabel.alpha = 0
      }
    }

    shapeLayerLeft.strokeAnimation(duration: speed, from: 1, to: 0)
    shapeLayerRight.strokeAnimation(duration: speed, from: 1, to: 0) {
      self.shapeLayerRight.isHidden = true
      self.shapeLayerLeft.isHidden = true
      self.shapeLayer.isHidden = false
      self.shapeLayer.strokeAnimation(duration: self.speed/2, from: 0, to: 1) {
        self.completedFlow = true
        self.shapeLayer.isHidden = true
        self.becomeFirstResponder()
      }
      self.shapeLayer.animatePosition(yPoint: 15, duration: self.speed/2)
    }
  }

  @objc func resignResponder() {
    if let text = text, text.isEmpty  {
      UIView.animate(withDuration: speed) {
        self.floatingLabel.alpha = 1
      }
    }
    completedFlow = false
    shapeLayer.isHidden = false
    shapeLayer.animatePosition(fromPoint: shapeLayer.position.y ,yPoint: -5, duration: self.speed/2)
    shapeLayer.strokeAnimation(duration: self.speed/2, from: 1, to: 0) {

      self.shapeLayer.isHidden = true
      self.shapeLayerLeft.isHidden = false
      self.shapeLayerRight.isHidden = false
      self.shapeLayerLeft.strokeAnimation(duration: self.speed, from: 0, to: 1)
      self.shapeLayerRight.strokeAnimation(duration: self.speed, from: 0, to: 1)
    }
  }

  @objc func textChanged() {
    setCursor()
    becomeFirstResponder()
  }

  private func setCursor() {
    cursorPosition = super.caretRect(for: self.selectedTextRange!.start).origin.x
    if textAlignment == .center {
      cursorPosition += offset
      cursorPosition += CGFloat(Int(bounds.maxX)/200)
    } else if textAlignment == .right || textAlignment == .left {
      cursorPosition += offset
    }
  }

  @objc func allEvents() {
    setCursor()
    updatePaths(midPoint: cursorPosition)
    print("all event:\(cursorPosition)")
  }
}

public extension JDAnimatedTextField {
  func showError(with message: String) {
    heightErrorLabelConstraint.constant = offset
    errorLabel.text = message
    errorLabel.shake()
  }

  func hideError() {
    heightErrorLabelConstraint.constant = 0
    errorLabel.text = nil
  }
}

extension JDAnimatedTextField {
  open override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return adjustedTextBounds(super.editingRect(forBounds: bounds))
  }

  open override func textRect(forBounds bounds: CGRect) -> CGRect {
    return adjustedTextBounds(super.textRect(forBounds: bounds))
  }

  private func adjustedTextBounds(_ bounds: CGRect) -> CGRect {
    CGRect(x: bounds.origin.x + offset, y: bounds.origin.y, width: bounds.size.width - offset*2, height: bounds.size.height)
  }
}
