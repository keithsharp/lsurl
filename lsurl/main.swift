//
//  main.swift
//  lsurl
//
//  Created by Keith Sharp on 27/06/2022.
//

import ArgumentParser
import Foundation
import System

enum UrlError: Error {
    case noSuchFile(path: String)
    case urlCreateFailure(path: String)
}

extension UrlError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .noSuchFile(path):
            return NSLocalizedString(
                "No such file or directory: \(path)",
                comment: "No such file or directory: "
            )
        case let .urlCreateFailure(path):
            return NSLocalizedString(
                "Could not create URL for path: \(path)",
                comment: "URL Creation failed"
            )
        }
    }
}

struct LsUrl: ParsableCommand {
    
    @Argument var paths: [String] = ["."]
    
    func run() {
        let fm = FileManager.default
        
        let _ = paths.map { path in
            if fm.fileExists(atPath: path) {
                if let url = URL(FilePath(path)) {
                    print(url.absoluteString)
                } else {
                    LsUrl.exit(withError: UrlError.urlCreateFailure(path: path))
                }
            } else {
                LsUrl.exit(withError: UrlError.noSuchFile(path: path))
            }
        }
    }
}

LsUrl.main()
exit(EXIT_SUCCESS)
