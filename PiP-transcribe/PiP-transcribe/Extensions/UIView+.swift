//
//  UIView+.swift
//  PiP-transcribe
//
//  Created by kazunori.aoki on 2021/12/08.
//

import UIKit

extension UIView {

    var uiImage: UIImage {
        let imageRenderer = UIGraphicsImageRenderer.init(size: bounds.size)
        return imageRenderer.image { context in
            layer.render(in: context.cgContext)
        }
    }
}
