//
//  UIFluidGradientView.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.06.2023.
//

import FluidGradient
import SwiftUI
import UIKit

class UIFluidGradientView: UIHostingController<FluidGradientWrapper> {
    init(blobs: [UIColor], highlights: [UIColor], speed: CGFloat = 1, blur: CGFloat = 0.75) {
        let view = FluidGradientWrapper(blobs: blobs, highlights: highlights, speed: speed, blur: blur)
        super.init(rootView: view)
    }

    @available(*, unavailable)
    @MainActor dynamic required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct FluidGradientWrapper: View {
    private var blobs: [UIColor]
    private var highlights: [UIColor]
    private var speed: CGFloat
    private var blur: CGFloat

    @State var blurValue: CGFloat = 0.0

    fileprivate init(blobs: [UIColor], highlights: [UIColor], speed: CGFloat = 1, blur: CGFloat = 0.75) {
        self.blobs = blobs
        self.highlights = highlights
        self.speed = speed
        self.blur = blur
    }

    var body: some View {
        FluidGradient(blobs: blobs.map { Color(uiColor: $0) }, highlights: highlights.map { Color(uiColor: $0) }, speed: speed, blur: blur)
            .ignoresSafeArea()
    }
}
