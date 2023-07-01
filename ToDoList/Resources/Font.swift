//
//  Font.swift
//

import UIKit

enum Font {
    case largeTitle
    case title
    case headline
    case body
    case subhead
    case footnote

    var font: UIFont {
        switch self {
        case .largeTitle:
            return UIFont.boldSystemFont(ofSize: 38)
        case .title:
            return UIFont.boldSystemFont(ofSize: 17)
        case .headline:
            return UIFont.boldSystemFont(ofSize: 17)
        case .body:
            return UIFont.systemFont(ofSize: 17)
        case .subhead:
            return UIFont.systemFont(ofSize: 15)
        case .footnote:
            return UIFont.boldSystemFont(ofSize: 13)
        }
    }
}
