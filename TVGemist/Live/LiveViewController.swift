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
    private var epgs = [LiveEPG]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cells
        collectionView.register(UINib(nibName: LiveChannelCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: LiveChannelCollectionViewCell.reuseIdentifier)
        
        // set initial background image
        backgroundImageView.image = UIImage(named: "PlaceholderImage")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLiveChannels()
    }
    
    // MARK: Networking
    
    private func fetchLiveChannels() {
        NPOKit.shared.fetchLiveChannels { [weak self] (result) in
            switch result {
            case .success(let components):
                let epgs = components.flatMap({ $0.epg }).flatMap({ $0 })
                
                if self?.epgs.count != epgs.count {
                    self?.epgs = epgs
                    self?.collectionView.reloadData()
                } else {
                    self?.updateLiveChannels(with: epgs)
                }
            case .failure(let error as NPOError):
                log.error("Could not fetch live channels (\(error.localizedDescription))")
            case.failure(let error):
                log.error("Could not fetch live channels (\(error.localizedDescription))")
            }
        }
    }
    
    private func updateLiveChannels(with epgs: [LiveEPG]) {
        for epg in epgs {
            guard let index = self.epgs.index(where: { $0 == epg }) else { continue }
            
            self.epgs[index] = epg

            let indexPath = IndexPath(row: index, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? LiveChannelCollectionViewCell {
                cell.configure(withEPG: epg)
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
        return epgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiveChannelCollectionViewCell.reuseIdentifier, for: indexPath) as! LiveChannelCollectionViewCell
        cell.configure(withEPG: epgs[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension LiveViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let liveStream = epgs[indexPath.row].channel.liveStream
        let playerViewController = PlayerViewController()
        present(playerViewController, animated: true) {
            playerViewController.play(liveStream: liveStream)
        }
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        guard let cell = collectionView.visibleCells.first(where: { $0.isFocused }) as? LiveChannelCollectionViewCell, let image = cell.liveChannelImage else { return }
        self.backgroundImageView.image = image
    }
}
