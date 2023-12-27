//
//  ExtendedTapAreaButton.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 27.12.2023.
//

import Foundation
import UIKit

class ExtendedTapAreaButton: UIButton {

    // Увеличиваем область нажатия без изменения фрейма
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let increasedBounds = bounds.insetBy(dx: -20, dy: -20)
        return increasedBounds.contains(point)
    }
}
