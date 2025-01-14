//
//  VibrantEffect.swift
//  Aurora Editor
//
//  Created by Wesley de Groot on 17/01/2023.
//  Copyright © 2023 Aurora Company. All rights reserved.
//

import SwiftUI

/// Vibrant effect
struct VibrantEffect: NSViewRepresentable {
    /// Make NS view
    ///
    /// - Parameter context: context
    /// 
    /// - Returns: NSVisualEffectView
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()

        view.blendingMode = .behindWindow
        view.state = .active
        view.material = .underWindowBackground

        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        //
    }
}
