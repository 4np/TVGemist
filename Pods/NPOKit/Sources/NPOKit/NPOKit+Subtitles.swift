//
//  NPOKit+Subtitles.swift
//  NPOKitPackageDescription
//
//  Created by Jeroen Wesbeek on 11/02/2018.
//

import Foundation

public typealias SubtitleLine = (number: Int, from: TimeInterval, to: TimeInterval, text: String)

public extension NPOKit {

    internal func fetchSubtitles(for item: Item, completionHandler: @escaping (Result<[Subtitle]>) -> Void) {
        guard let id = item.id else {
            let error = NPOError.missingIdentifier
            completionHandler(.failure(error))
            return
        }
        
        fetchModel(ofType: Media.self, forEndpoint: "media/\(id)", postData: nil) { (result) in
            switch result {
            case .success(let media):
                completionHandler(.success(media.subtitles))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func fetchSubtitleContents(for item: Item, completionHandler: @escaping (Result<String>) -> Void) {
        fetchSubtitles(for: item) { (result) in
            switch result {
            case .success(let subtitles):
                guard let url = subtitles.first(where: { $0.type == .srt })?.url else {
                    let error = NPOError.subtitleNotAvailable
                    completionHandler(.failure(error))
                    return
                }
                
                // read subtitle contents
                do {
                    // about 50% of the subtitles fail using .utf8,
                    // using .macOSRoman which is more forgiving
                    let contents = try String(contentsOf: url, encoding: .macOSRoman)
                    completionHandler(.success(contents))
                } catch let error {
                    completionHandler(.failure(error))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func fetchSubtitle(for item: Item, completionHandler: @escaping (Result<[SubtitleLine]>) -> Void) {
        fetchSubtitleContents(for: item) { (result) in
            // parse srt / webvtt style subtitles
            let pattern = "(\\d+)\\n([\\d:,.]+)\\s+-{2}\\>\\s+([\\d:,.]+)\\n([\\s\\S]*?(?=\\n{2,}|$))"

            guard case let .success(contents) = result, let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
                let error = NPOError.subtitleNotAvailable
                completionHandler(.failure(error))
                return
            }
            
            let matches = regex.matches(in: contents, range: NSRange(location: 0, length: contents.utf16.count))
            let lines = matches.map { (result) -> SubtitleLine? in
                // 762\n01:03:07.007 --> 01:03:11.024\nOp 2doc.nl vindt u meer dan 1000 documentaires, interviews en tips.
                guard
                    let index = self.integer(for: result, index: 1, contents: contents),
                    let from = self.timeInterval(for: result, index: 2, contents: contents),
                    let to = self.timeInterval(for: result, index: 3, contents: contents),
                    let text = self.string(for: result, index: 4, contents: contents)
                    else { return nil }

                return SubtitleLine(number: index, from: from, to: to, text: text)
            }
            
            // remove optionals
            let nonOptionalLines = lines.compactMap({ $0 })
            
            completionHandler(.success(nonOptionalLines))
        }
    }
    
    private func string(for result: NSTextCheckingResult, index: Int, contents: String) -> String? {
        let range = result.range(at: index)
        let start = String.UTF16Index(encodedOffset: range.location)
        let end = String.UTF16Index(encodedOffset: range.location + range.length)
        return String(contents.utf16[start..<end])
    }
    
    private func integer(for result: NSTextCheckingResult, index: Int, contents: String) -> Int? {
        guard let value = self.string(for: result, index: index, contents: contents) else { return nil }
        return Int(value)
    }
    
    private func timeInterval(for result: NSTextCheckingResult, index: Int, contents: String) -> TimeInterval? {
        guard
            let elements = self.string(for: result, index: index, contents: contents)?.components(separatedBy: ":"),
            elements.count == 3,
            let hours = Double(elements[0]),
            let minutes = Double(elements[1]),
            let seconds = Double(elements[2].replacingOccurrences(of: ",", with: "."))
            else { return nil }
        
        return (hours * 3600.0 + minutes * 60.0 + seconds)
    }
}
