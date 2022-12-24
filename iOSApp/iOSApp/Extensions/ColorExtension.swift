//
//  ColorExtension.swift
//  iOSApp
//
//  Created by Neal Archival on 12/23/22.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        // Note: 0xff = 255
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        // sRGB color space clamps each color component — red, green, and blue — to a range of 0 to 1, but SwiftUI colors use an extended sRGB color space
        // so you can use component values outside that range. This makes it possible to create colors using the Color.RGBColorSpace.sRGB (apple documentation)
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
