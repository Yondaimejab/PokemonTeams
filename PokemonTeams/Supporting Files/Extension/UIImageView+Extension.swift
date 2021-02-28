//
//  UIImageView+Extension.swift
//  InstagramClone
//
//  Created by Joel Alcantara burgos on 21/2/21.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageFrom(url: URL?) {
        if let url = url {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    if let retrivedImage = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.image = retrivedImage
                        }
                    }
                }
            }
        }
    }
}
