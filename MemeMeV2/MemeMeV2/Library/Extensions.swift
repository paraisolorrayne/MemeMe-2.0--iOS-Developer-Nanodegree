//
//  Extensions.swift
//  MemeMeV1
//
//  Created by cedro_nds on 21/07/18.
//  Copyright © 2018 Lorrayne Paraiso. All rights reserved.
//

import Foundation
import UIKit

extension CGImage {
    var isDark: Bool {
        get {
            guard let imageData = self.dataProvider?.data else { return false }
            guard let ptr = CFDataGetBytePtr(imageData) else { return false }
            let length = CFDataGetLength(imageData)
            let threshold = Int(Double(self.width * self.height) * 0.45)
            var darkPixels = 0
            for i in stride(from: 0, to: length, by: 4) {
                let r = ptr[i]
                let g = ptr[i + 1]
                let b = ptr[i + 2]
                let luminance = (0.299 * Double(r) + 0.587 * Double(g) + 0.114 * Double(b))
                if luminance < 150 {
                    darkPixels += 1
                    if darkPixels > threshold {
                        return true
                    }
                }
            }
            return false
        }
    }
}

extension UIImage {
    var isDark: Bool {
        get {
            return self.cgImage?.isDark ?? false
        }
    }
    func makeTintable() -> UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }
}

extension UIImageView {
    func tintTo(color: UIColor) {
        self.tintColor = color
    }
}
