//
//  CustomTextField.swift
//  weaning
//
//  Created by Yuri Cavallin on 20/6/23.
//

import UIKit

final class CustomTextField: UITextField {

    private var viewModel: CustomTextFieldViewModel?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureAppearance()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAppearance()
    }

    func configureAppearance() {
        self.backgroundColor = .clear
        self.font = .regularFontOf(size: 16)
        // roundCornersSimplified(cornerRadius: .defaultCornerRadius, borderWidth: 0.5, borderColor: .mainColor)
        self.underlined(color: .lightGray)
    }

    func configureWith(_ viewModel: CustomTextFieldViewModel) {
        self.viewModel = viewModel

        self.placeholder = viewModel.placeholder
    }

    func underlined(color: UIColor) {
        self.layer.sublayers?.forEach { $0.borderWidth = 0 }
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0,
                              y: self.frame.size.height - width,
                              width: self.frame.size.width,
                              height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }

    /// Used to inset the bounds of the text field. The x values is applied as horizontal insets and the y value is applied as vertical insets.
    private var centerInset: CGPoint = .init(x: 15, y: 0) {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: - UITextField

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        insetTextRect(forBounds: bounds)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        insetTextRect(forBounds: bounds)
    }

    private func insetTextRect(forBounds bounds: CGRect) -> CGRect {
        let insetBounds = bounds.insetBy(dx: centerInset.x, dy: centerInset.y)
        return insetBounds
    }

}
