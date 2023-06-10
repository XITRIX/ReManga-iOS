//
//  UIFluidGradientView.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.06.2023.
//

import FluidGradient
import IrregularGradient
import SwiftUI
import UIKit

class UIFluidGradientView: UIHostingController<FluidGradient> {
    init(blobs: [UIColor], highlights: [UIColor], speed: CGFloat = 1, blur: CGFloat = 0.75) {
        let view = FluidGradient(blobs: blobs.map { Color(uiColor: $0) }, highlights: highlights.map { Color(uiColor: $0) }, speed: speed, blur: blur)
        super.init(rootView: view)
    }

    @available(*, unavailable)
    @MainActor dynamic required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
