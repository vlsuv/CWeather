//
//  LocationListController.swift
//  CWeather
//
//  Created by vlsuv on 21.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import RealmSwift

class LocationListController: UIViewController {
    
    // MARK: - Properties
    var tableView: UITableView?
        
    private var realmManager: RealmManager?
    
    private var locations: Results<Location>?
    
    var didSelectLocation: ((String) -> ())?
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white
        
        configureNavigationController()
        configureTableView()
        
        setupRealmManager()
        
        getLocations()
    }
    
    // MARK: - Targets
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Handlers
    private func configureNavigationController() {
        let backButton = UIBarButtonItem(image: Images.back, style: .plain, target: self, action: #selector(didTapBackButton))
        backButton.tintColor = Colors.black
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func configureTableView() {
        tableView = UITableView()
        
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView?.dataSource = self
        tableView?.delegate = self
        
        tableView?.tableFooterView = UIView()
        
        view.addSubview(tableView!)
        tableView?.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
    }
}

// MARK: - Realm
extension LocationListController {
    private func setupRealmManager() {
        realmManager = RealmManager()
    }
    
    private func getLocations() {
        realmManager?.getLocations(completionHandler: { [weak self] results in
            self?.locations = results
            self?.tableView?.reloadData()
        })
    }
}

// MARK: - UITableViewDataSource
extension LocationListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let location = locations?[indexPath.row] {
            cell.textLabel?.text = location.name
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension LocationListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let location = locations?[indexPath.row] else { return }
        didSelectLocation?(location.name)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let location = locations?[indexPath.row] else { return }
            
            realmManager?.deleteLocation(location, completionHandler: { succes in
                self.tableView?.reloadData()
            })
        }
    }
}
