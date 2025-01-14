//
//  BreadcrumbsView.swift
//  Aurora Editor
//
//  Created by Lukas Pistrol on 17.03.22.
//  Copyright © 2023 Aurora Company. All rights reserved.
//

import SwiftUI

/// A view that represents the breadcrumbs.
public struct BreadcrumbsView: View {
    /// The color scheme.
    @Environment(\.colorScheme)
    private var colorScheme

    /// The active state.
    @Environment(\.controlActiveState)
    private var activeState

    /// The file items.
    @State
    private var fileItems: [FileSystemClient.FileItem] = []

    /// The file.
    private let file: FileSystemClient.FileItem

    /// The tapped open file closure.
    private let tappedOpenFile: (FileSystemClient.FileItem) -> Void

    /// Creates a new instance of `BreadcrumbsView`.
    /// 
    /// - Parameter file: The file.
    /// - Parameter tappedOpenFile: The tapped open file closure.
    public init(
        file: FileSystemClient.FileItem,
        tappedOpenFile: @escaping (FileSystemClient.FileItem) -> Void
    ) {
        self.file = file
        self.tappedOpenFile = tappedOpenFile
    }

    /// The view body.
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 1.5) {
                ForEach(fileItems, id: \.self) { fileItem in
                    if fileItem.parent != nil {
                        chevron
                    }
                    BreadcrumbsComponent(fileItem: fileItem, tappedOpenFile: tappedOpenFile)
                        .padding(.leading, 2.5)
                }
            }
            .padding(.horizontal, 10)
        }
        .frame(height: 28, alignment: .center)
        .background {
            EffectView(
                NSVisualEffectView.Material.contentBackground,
                blendingMode: NSVisualEffectView.BlendingMode.withinWindow
            )
        }
        .onAppear {
            fileInfo(self.file)
        }
        .onChange(of: file) { newFile in
            fileInfo(newFile)
        }
    }

    /// Chrevron divider.
    private var chevron: some View {
        Image(systemName: "chevron.compact.right")
            .font(.system(size: 18, weight: .thin, design: .monospaced))
            .foregroundStyle(.primary)
            .accessibilityHidden(true)
            .opacity(activeState != .inactive ? 0.8 : 0.5)
    }

    /// File info.
    /// 
    /// - Parameter file: The file.
    private func fileInfo(_ file: FileSystemClient.FileItem) {
        fileItems = []
        var currentFile: FileSystemClient.FileItem? = file
        while let currentFileLoop = currentFile {
            fileItems.insert(currentFileLoop, at: 0)
            currentFile = currentFileLoop.parent
        }
    }
}

struct BreadcrumbsView_Previews: PreviewProvider {
    static var previews: some View {
        BreadcrumbsView(file: .init(url: .init(fileURLWithPath: ""))) { _ in }
            .previewLayout(.fixed(width: 500, height: 29))
            .preferredColorScheme(.dark)

        BreadcrumbsView(file: .init(url: .init(fileURLWithPath: ""))) { _ in }
            .previewLayout(.fixed(width: 500, height: 29))
            .preferredColorScheme(.light)
    }
}
