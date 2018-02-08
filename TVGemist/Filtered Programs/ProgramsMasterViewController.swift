//
//  ProgramsMasterViewController.swift
//  TVGemist
//
//  Created by Jeroen Wesbeek on 14/12/2017.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import Foundation
import UIKit
import NPOKit

protocol ProgramsMasterViewControllerDelegate: class {
    func toggle(programFilter: ProgramFilter)
    func set(defaultProgramFilters: [ProgramFilter])
}

class ProgramsMasterViewController: UITableViewController {
    private var paginator: Paginator<Item>?
    private var filters = [Filter]()
    weak var delegate: ProgramsMasterViewControllerDelegate?
    private var lastUpdated: Date?
    private var shouldRefreshFilters: Bool {
        guard let lastUpdated = lastUpdated else { return true }
        
        // only refresh every other day to make sure the date filter headers reliably update
        var calendar = Calendar.current
        //swiftlint:disable:next force_unwrapping
        calendar.timeZone = TimeZone(abbreviation: "CET")!
        return !calendar.isDate(Date(), inSameDayAs: lastUpdated)
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure delegate
        if let detailViewController = splitViewController?.viewControllers.last as? ProgramsDetailViewController {
            self.delegate = detailViewController
        }
        
        title = ""
        
        // register cells
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: FilterTableViewCell.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if shouldRefreshFilters {
            // update filters
            setupPaginator()
            lastUpdated = Date()
        }
    }
    
    // MARK: Networking
    
    private func setupPaginator() {
        log.debug("Fetching program filters")
        
        paginator = NPOKit.shared.getProgramPaginator { [weak self] (result) in
            switch result {
            case .success(let paginator, _):
                guard let filters = paginator.filters else { return }
                self?.filters = filters
                self?.tableView.reloadData()
                self?.applyDefaultFilters()
            case .failure(let error as NPOError):
                log.error("Could not fetch filters (\(error.localizedDescription))")
            case.failure(let error):
                log.error("Could not fetch filters (\(error.localizedDescription))")
            }
        }
        
        // fetch the first page
        paginator?.next()
    }
    
    // MARK: Apply default filters
    
    func applyDefaultFilters() {
        var defaultProgramFilters = [ProgramFilter]()
        
        for (section, filter) in filters.enumerated() {
            guard let defaultOption = filter.options.filter({ $0.isDefault }).first else { continue }
            let programFilter = ProgramFilter(filter: filter, option: defaultOption)
            defaultProgramFilters.append(programFilter)
            
            // handle selection state
            if let row = filter.options.index(of: defaultOption) {
                let indexPath = IndexPath(row: row, section: section)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
            }
        }
        
        guard defaultProgramFilters.count > 0 else { return }
        
        delegate?.set(defaultProgramFilters: defaultProgramFilters)
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return filters.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filters[section].title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters[section].options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.reuseIdentifier, for: indexPath) as! FilterTableViewCell
        cell.configure(with: filters[indexPath.section].options[indexPath.row])
        return cell
    }

    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .orange
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filter = filters[indexPath.section]
        let option = filter.options[indexPath.row]
        let programFilter = ProgramFilter(filter: filter, option: option)
        toggle(programFilter: programFilter)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let filter = filters[indexPath.section]
        let option = filter.options[indexPath.row]
        let programFilter = ProgramFilter(filter: filter, option: option)
        delegate?.toggle(programFilter: programFilter)
    }
    
    private func toggle(programFilter: ProgramFilter) {
        //log.debug("Toggle program filter: \(programFilter)")
        let section = filters.index(of: programFilter.filter)
        let row = programFilter.filter.options.index(of: programFilter.option)
        
        // we only allow one selected cell per section
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows?.filter({ $0.section == section && $0.row != row }) {
            for indexPath in selectedIndexPaths {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        delegate?.toggle(programFilter: programFilter)
    }
}
