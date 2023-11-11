import SwiftUI

extension Color {
    static var dark: Color {
        return Color(hex: "2F2E41")
    }
    
    static var light: Color {
        return Color(hex: "6C63FF")
    }
    
    static var lightGray: Color {
        return Color(hex: "CBCBCB")
    }
    
    static var hundred: Color {
        return Color(hex: "38B2AC")
    }
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#") // Skip the hash mark if it's there
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}
