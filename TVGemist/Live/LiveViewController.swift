//
//  LiveViewController.swift
//  TVGemist
//
//  Created by Jeroen Wesbeek on 09/02/2018.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import Foundation
import UIKit
import NPOKit

class LiveViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private lazy var backgroundImageView: UIImageView = {
        // define frame
        let frame = CGRect(x: 0, y: 0, width: 1920, height: 1080)
        
        // create image view
        let imageView = UIImageView(frame: frame)
        
        // add visual effect view
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.frame = imageView.frame
        imageView.addSubview(visualEffectView)
        
        // add to image view to view
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
        return imageView
    }()
    private var liveBroadcasts = [LiveBroadcast]()
    private var regionalBroadcasts = [LocalBroadcast]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cells
        collectionView.register(UINib(nibName: LiveBroadcastCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: LiveBroadcastCollectionViewCell.reuseIdentifier)
        collectionView.register(UINib(nibName: LocalBroadcastCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: LocalBroadcastCollectionViewCell.reuseIdentifier)

        // set initial background image
        backgroundImageView.image = UIImage(named: "PlaceholderImage")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLiveBroadcasts()
        fetchRegionalBroadcasts()
    }
    
    // MARK: Networking
    
    private func fetchLiveBroadcasts() {
        // fetch live broadcasts
        NPOKit.shared.fetchLiveBroadcasts { [weak self] (result) in
            switch result {
            case .success(let broadcasts):
                if self?.liveBroadcasts.count != broadcasts.count {
                    self?.liveBroadcasts = broadcasts
                    self?.collectionView.reloadData()
                } else {
                    self?.updateLiveBroadcasts(with: broadcasts)
                }
            case .failure(let error as NPOError):
                log.error("Could not fetch live channels (\(error.localizedDescription))")
            case .failure(let error):
                log.error("Could not fetch live channels (\(error.localizedDescription))")
            }
        }
    }
    
    private func fetchRegionalBroadcasts() {
        // fetch regional broadcasts
        NPOKit.shared.fetchRegionalBroadcasts { [weak self] (result) in
            switch result {
            case .success(let broadcasts):
                if self?.regionalBroadcasts.count != broadcasts.count {
                    self?.regionalBroadcasts = broadcasts
                    self?.collectionView.reloadData()
                } else {
                    self?.updateRegionalBroadcasts(with: broadcasts)
                }
            case .failure(let error as NPOError):
                log.error("Could not fetch local channels (\(error.localizedDescription))")
            case .failure(let error):
                log.error("Could not fetch local channels (\(error.localizedDescription))")
            }
        }
    }
    
    private func updateLiveBroadcasts(with broadcasts: [LiveBroadcast]) {
        for broadcast in broadcasts {
            guard let index = self.liveBroadcasts.index(where: { $0 == broadcast }) else { continue }
            
            self.liveBroadcasts[index] = broadcast

            let indexPath = IndexPath(row: index, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? LiveBroadcastCollectionViewCell {
                cell.configure(with: broadcast)
            }
        }
    }
    
    private func updateRegionalBroadcasts(with broadcasts: [LocalBroadcast]) {
        for broadcast in broadcasts {
            guard let index = self.regionalBroadcasts.index(where: { $0 == broadcast }) else { continue }
            
            self.regionalBroadcasts[index] = broadcast
            
            let indexPath = IndexPath(row: index, section: 1)
            if let cell = collectionView.cellForItem(at: indexPath) as? LocalBroadcastCollectionViewCell {
                cell.configure(with: broadcast)
            }
        }
    }
}

// MARK: UICollectionViewDataSource
extension LiveViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return liveBroadcasts.count
        case 1:
            return regionalBroadcasts.count
        default:
            fatalError("Unexpected section \(section)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            return self.collectionView(collectionView, liveBroadcastCellForItemAt: indexPath)
        case 1:
            return self.collectionView(collectionView, regionalBroadcastCellForItemAt: indexPath)
        default:
            fatalError("Unexpected section \(indexPath.section)")
        }
    }
    
    private func collectionView(_ collectionView: UICollectionView, liveBroadcastCellForItemAt indexPath: IndexPath) -> LiveBroadcastCollectionViewCell {
        //swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiveBroadcastCollectionViewCell.reuseIdentifier, for: indexPath) as! LiveBroadcastCollectionViewCell
        cell.configure(with: liveBroadcasts[indexPath.row])
        return cell
    }
    
    private func collectionView(_ collectionView: UICollectionView, regionalBroadcastCellForItemAt indexPath: IndexPath) -> LocalBroadcastCollectionViewCell {
        //swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocalBroadcastCollectionViewCell.reuseIdentifier, for: indexPath) as! LocalBroadcastCollectionViewCell
        cell.configure(with: regionalBroadcasts[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension LiveViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playerViewController = PlayerViewController()
        present(playerViewController, animated: true) {
            switch indexPath.section {
            case 0:
                playerViewController.play(liveBroadcast: self.liveBroadcasts[indexPath.row])
            case 1:
                playerViewController.play(localBroadcast: self.regionalBroadcasts[indexPath.row])
            default:
                fatalError("Unexpected section \(indexPath.section)")
            }
        }
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let cell = collectionView.visibleCells.first(where: { $0.isFocused }) as? LiveBroadcastCollectionViewCell, let image = cell.liveChannelImage {
            self.backgroundImageView.image = image
        }
    }
}
