//
//  URLExtensions.swift
//  WhiskyKit
//
//  Created by Isaac Marovitz on 13/06/2023.
//

import Foundation

extension String {
    public var esc: String {
        let esc = ["\\", "\"", "'", " ", "(", ")", "[", "]", "{", "}", "&", "|",
                   ";", "<", ">", "`", "$", "!", "*", "?", "#", "~", "="]
        var str = self
        for char in esc {
            str = str.replacingOccurrences(of: char, with: "\\" + char)
        }
        return str
    }
}

extension URL {
    public var esc: String {
        path.esc
    }

    public func prettyPath() -> String {
        var prettyPath = path(percentEncoded: false)
        prettyPath = prettyPath
            .replacingOccurrences(of: Bundle.main.bundleIdentifier ?? "com.isaacmarovitz.Whisky", with: "Whisky")
            .replacingOccurrences(of: "/Users/\(NSUserName())", with: "~")
        return prettyPath
    }

    // NOT to be used for logic only as UI decoration
    public func prettyPath(_ bottle: Bottle) -> String {
        var prettyPath = path(percentEncoded: false)
        prettyPath = prettyPath
            .replacingOccurrences(of: bottle.url.path(percentEncoded: false), with: "")
            .replacingOccurrences(of: "/drive_c/", with: "C:\\")
            .replacingOccurrences(of: "/", with: "\\")
        return prettyPath
    }

    // There is probably a better way to do this
    public func updateParentBottle(old: URL, new: URL) -> URL {
        let originalPath = path(percentEncoded: false)

        var oldBottlePath = old.path(percentEncoded: false)
        if oldBottlePath.last != "/" {
            oldBottlePath += "/"
        }

        var newBottlePath = new.path(percentEncoded: false)
        if newBottlePath.last != "/" {
            newBottlePath += "/"
        }

        let newPath = originalPath.replacingOccurrences(of: oldBottlePath,
                                                        with: newBottlePath)
        return URL(filePath: newPath)
    }
}

extension URL: Identifiable {
    public var id: URL { self }
}
