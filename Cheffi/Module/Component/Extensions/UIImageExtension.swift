//
//  UIImageExtension.swift
//  Cheffi
//
//  Created by 정건호 on 6/10/24.
//

import SwiftUI

extension UIImage {
    class func borderForTabBar(color: Color) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(UIColor(color).cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image ?? UIImage()
    }
}
