//
//  ProgramCollectionReusableView.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 29/10/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import UIKit
import XCGLogger
import NPOKit

class ProgramCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    static let nibName = "ProgramCollectionReusableView"
    static let reuseIdentifier = "ProgramCollectionReusableViewIdentifier"
    static let size = CGSize(width: 1920, height: 600)
    
    private var headerImageTask: URLSessionDataTask?
    
    // MARK: Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        headerImageView.image = nil
        titleLabel.text = nil
    }
    
    // MARK: Configuration
    
    func configure(withProgram program: Item) {
        titleLabel.text = program.title
        descriptionLabel.text = program.description
        detailsLabel.text = generateDetails(forProgram: program)
        getHeaderImage(forProgram: program, andSize: headerImageView.frame.size)
    }
    
    private func generateDetails(forProgram program: Item) -> String {
        var details = [String]()
        if !program.broadcasters.isEmpty {
            details.append(program.broadcasters.joined(separator: ", "))
        }
        if !program.genres.isEmpty {
            details.append(program.genres.flatMap({ $0.terms }).joined(separator: ", "))
        }
        return details.joined(separator: " • ")
    }
    
    // MARK: Images
    
    private func getHeaderImage(forProgram program: Item, andSize size: CGSize) {
        headerImageTask = NPOKit.shared.fetchHeaderImage(for: program) { [weak self] (result) in
            switch result {
            case .success(let image, let task):
                guard task == self?.headerImageTask else { return }
                self?.headerImageView.image = image.faceAwareAspectScaled(toFill: size)
            case .failure(let error as NPOError):
                log.error("Could not download header image for program \(program) and size \(size) (\(error.localizedDescription))")
            case.failure(let error):
                log.error("Could not download header image for program \(program) and size \(size) (\(error.localizedDescription))")
            }
        }
    }
}
