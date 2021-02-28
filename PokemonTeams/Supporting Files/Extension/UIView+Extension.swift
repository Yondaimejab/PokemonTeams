//
//  UIView+Extension.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 27/2/21.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    func addShadow(color: UIColor, opacity: Float = 1, offset: CGSize = .zero) {

        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset

        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    func removeShadow() {
        layer.shadowOpacity = 0.0
    }
}
