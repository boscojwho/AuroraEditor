//
//  LineThemeAttribute.swift
//  Aurora Editor
//
//  Created by Matthew Davidson on 21/12/19.
//  Copyright © 2023 Aurora Company. All rights reserved.
//

import Foundation
import AppKit

/// HighlightTheme attribute for applying a theme to a line,
/// specifically some mutation to an attributed strings `paragraphStyle`.
///
/// The mutable paragraph style will be applied to the whole line, when any token contains the attribute.
///
/// Paragraph styles will prioritise the theme attributes of narrower scopes and later tokens for a line.
@available(*, deprecated)
public protocol LineThemeAttribute: ThemeAttribute {
    func apply(to style: NSMutableParagraphStyle)
}
