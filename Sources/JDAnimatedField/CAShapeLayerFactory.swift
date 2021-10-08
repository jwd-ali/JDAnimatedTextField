import UIKit
public class CAShapeLayerFactory {

  public class func createShapeLayer<T: CAShapeLayer>(withFillColor fillColor: UIColor = .clear, strokeColor: UIColor = .blue, lineCap: CAShapeLayerLineCap = .square, lineWidth: CGFloat = 5) -> T {
    let shapeLayer = T()
    shapeLayer.fillColor = fillColor.cgColor
    shapeLayer.strokeColor = strokeColor.cgColor
    shapeLayer.lineCap = lineCap
    shapeLayer.lineWidth = lineWidth
    shapeLayer.shadowOffset = .zero
    shapeLayer.shadowOpacity = 0.1
    shapeLayer.shadowColor = UIColor.white.cgColor
    shapeLayer.shadowRadius = 10
    return shapeLayer
  }
}
