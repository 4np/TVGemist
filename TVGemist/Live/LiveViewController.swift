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
        self.view.sendSubview(toBack: imageView)
        
        return imageView
    }()
    private var broadcasts = [LiveBroadcast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cells
        collectionView.register(UINib(nibName: LiveBroadcastCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: LiveBroadcastCollectionViewCell.reuseIdentifier)
        
        // set initial background image
        backgroundImageView.image = UIImage(named: "PlaceholderImage")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLiveChannels()
    }
    
    // MARK: Networking
    
    private func fetchLiveChannels() {
        NPOKit.shared.fetchLiveBroadcasts { [weak self] (result) in
            switch result {
            case .success(let broadcasts):
                if self?.broadcasts.count != broadcasts.count {
                    self?.broadcasts = broadcasts
                    self?.collectionView.reloadData()
                } else {
                    self?.updateBroadcasts(with: broadcasts)
                }
            case .failure(let error as NPOError):
                log.error("Could not fetch live channels (\(error.localizedDescription))")
            case.failure(let error):
                log.error("Could not fetch live channels (\(error.localizedDescription))")
            }
        }
    }
    
    private func updateBroadcasts(with broadcasts: [LiveBroadcast]) {
        for broadcast in broadcasts {
            guard let index = self.broadcasts.index(where: { $0 == broadcast }) else { continue }
            
            self.broadcasts[index] = broadcast

            let indexPath = IndexPath(row: index, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? LiveBroadcastCollectionViewCell {
                cell.configure(with: broadcast)
            }
        }
    }
}

// MARK: UICollectionViewDataSource
extension LiveViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return broadcasts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiveBroadcastCollectionViewCell.reuseIdentifier, for: indexPath) as! LiveBroadcastCollectionViewCell
        cell.configure(with: broadcasts[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension LiveViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playerViewController = PlayerViewController()
        present(playerViewController, animated: true) {
            playerViewController.play(broadcast: self.broadcasts[indexPath.row])
        }
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        guard let cell = collectionView.visibleCells.first(where: { $0.isFocused }) as? LiveBroadcastCollectionViewCell, let image = cell.liveChannelImage else { return }
        self.backgroundImageView.image = image
    }
}
