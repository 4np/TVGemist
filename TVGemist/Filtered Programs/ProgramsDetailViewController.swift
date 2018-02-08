//
//  ProgramsDetailViewController.swift
//  TVGemist
//
//  Created by Jeroen Wesbeek on 14/12/2017.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import UIKit
import NPOKit

protocol ProgramsDetailViewControllerDelegate: class {
    func didUpdateProgram(withImage image: UIImage?)
    func setInitialBackgroundIfNeeded(for program: Program)
}

class ProgramsDetailViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    weak var delegate: ProgramsDetailViewControllerDelegate?
    private var programFilters = [ProgramFilter]() {
        didSet {
            resetPaginator()
        }
    }
    private var paginator: Paginator<Item>?
    private var programs = [Item]()
    private var lastUpdated: Date?
    //swiftlint:disable:next force_unwrapping
    private var resetInterval: TimeInterval = TimeInterval(exactly: 60 * 20)! // every 20 minutes
    private var shouldResetPaginator: Bool {
        guard let lastUpdated = lastUpdated else { return true }
        
        let checkDate = Date(timeInterval: resetInterval, since: lastUpdated)
        let now = Date()
        return now > checkDate
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cells
        collectionView.register(UINib(nibName: ProgramCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: ProgramCollectionViewCell.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if shouldResetPaginator {
            resetPaginator()
        }
    }
    
    // MARK: Networking
    
    private func resetPaginator() {
        // clear programs
        programs = [Item]()
        
        collectionView.reloadData()
        
        // setup paginator
        setupPaginator()
    }
    
    private func setupPaginator() {
        log.debug("Fetching programs")
        
        lastUpdated = Date()
        
        paginator = NPOKit.shared.getProgramPaginator(using: programFilters) { [weak self] (result) in
            switch result {
            case .success(let paginator, let programs):
                log.debug("Page \(paginator.page) of \(paginator.numberOfPages) (\(programs.count) filtered programs)")
                self?.add(new: programs)
                
                if paginator.page == 1, let program = programs.first {
                    self?.delegate?.setInitialBackgroundIfNeeded(for: program)
                }
            case .failure(let error as NPOError):
                log.error("Could not fetch filtered programs (\(error.localizedDescription))")
            case.failure(let error):
                log.error("Could not fetch filtered programs (\(error.localizedDescription))")
            }
        }
        
        // fetch the first page
        paginator?.next()
    }
    
    // MARK: Adding programs
    
    private func add(new newPrograms: [Item]) {
        var indexPaths = [IndexPath]()
        
        for program in newPrograms {
            indexPaths.append(IndexPath(row: programs.count, section: 0))
            programs.append(program)
        }
        
        collectionView?.insertItems(at: indexPaths)
    }
}

// MARK: ProgramsMasterViewControllerDelegate
extension ProgramsDetailViewController: ProgramsMasterViewControllerDelegate {
    func toggle(programFilter: ProgramFilter) {
        if let index = programFilters.index(of: programFilter) {
            programFilters.remove(at: index)
        } else if let index = programFilters.index(where: { $0.filter == programFilter.filter }) {
            var newProgramFilters = programFilters
            newProgramFilters.remove(at: index)
            newProgramFilters.append(programFilter)
            programFilters = newProgramFilters
        } else {
            programFilters.append(programFilter)
        }
    }
    
    func set(defaultProgramFilters programFilters: [ProgramFilter]) {
        self.programFilters.append(contentsOf: programFilters)
    }
}

// MARK: UIScrollViewDelegate
extension ProgramsDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = collectionView, let paginator = paginator else { return }
        
        let numberOfPagesToInitiallyFetch = 2
        let yOffsetToLoadNextPage = collectionView.contentSize.height - (collectionView.bounds.height * CGFloat(numberOfPagesToInitiallyFetch))
        
        guard scrollView.contentOffset.y > yOffsetToLoadNextPage else { return }
        
        paginator.next()
    }
}

// MARK: UICollectionViewDataSource
extension ProgramsDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return programs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgramCollectionViewCell.reuseIdentifier, for: indexPath) as! ProgramCollectionViewCell
        cell.configure(withProgram: self.programs[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension ProgramsDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        guard let cell = collectionView.visibleCells.first(where: { $0.isFocused }) as? ProgramCollectionViewCell, let programImage = cell.programImage else { return }
        delegate?.didUpdateProgram(withImage: programImage)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let program = programs[indexPath.row]
        
        if program.isOnlyOnNPOPlus {
            displayNPOPlusWarning(for: program)
        } else {
            let programViewController = ProgramViewController.fromStoryboard()
            programViewController.configure(withProgram: programs[indexPath.row])
            present(programViewController, animated: true, completion: nil)
        }
    }
    
    private func displayNPOPlusWarning(for program: Program) {
        // i18n
        let titleFormat = "'%@' is not available".localized(withComment: "Program not available alert title")
        let title = String.localizedStringWithFormat(titleFormat, program.title)
        let messageFormat = "This program is exclusively available on NPO Start Plus and hence cannot be watched.\n\n\"%@\"".localized(withComment: "Program not available alert message")
        let message = String.localizedStringWithFormat(messageFormat, program.description ?? "")
        
        // create alert
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: String.okAlertAction, style: .cancel) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        
        // present alert
        present(alertController, animated: true, completion: nil)
    }
}
