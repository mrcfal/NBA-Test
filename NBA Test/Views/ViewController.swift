//
//  ViewController.swift
//  NBA Test
//
//  Created by Marco Falanga on 17/02/21.
//

import UIKit
import Combine

/// Root view controller of the navigation stack. It shows the list of teams.
///
/// You can filter the teams by name, using the searchBar in the navigationBar, and/or by conference, using the segmentControl on top of the screen.
///
/// The subviews are:
/// - segmentControl: to filter teams based on the conference;
/// - collectionView: set using diffable data source
/// - activityIndicatorView: which appears during the url data task
///
/// As the view is loaded, playersManager attempts to get all the players and teamsManager attempts to get all the teams (if the latter fails, an alert is presented). Note: the playersManager's error is not handled in this controller but when you present a DetailTeamViewController (it tries to get all the players again and if it fails again it shows an alert).
class ViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, TeamModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, TeamModel>
    
    private var segmentControl: UISegmentedControl!
    private var collectionView: UICollectionView!

    private let teamsManager = TeamsViewModel()
    private let filtersVM = FilterTeamsViewModel()
    private var subscriptions = Set<AnyCancellable>()
    private lazy var dataSource = makeDataSource()
    
    private var activityIndicatorView: UIActivityIndicatorView!

    private var filteredTeams = [TeamModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setSegmentControl()
        setCollection()
        setActivityIndicatorView()
        setSearchController()
        setSubscriptions()
        teamsManager.get()
        applySnapshot(animatingDifferences: false)
        
        self.navigationItem.title = "NBA"
    }
    
    private func setSegmentControl() {
        let items = ConferenceType.allCases.map({ $0.rawValue })
        segmentControl = UISegmentedControl(items: items)
        view.addSubview(segmentControl)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -20).isActive = true
        segmentControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        
        for index in 0..<segmentControl.numberOfSegments {
            segmentControl.setAction(UIAction(handler: { [weak self] (action) in
                self?.filtersVM.conference = ConferenceType.allCases[index]
            }), forSegmentAt: index)
            segmentControl.setTitle(items[index], forSegmentAt: index)
        }
    }
    
    private func setCollection() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createColumsFlowLayout(columns: 3, headerSize: nil, in: view))
        collectionView.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 10).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        collectionView.delegate = self
        
        collectionView.register(TeamCollectionViewCell.self, forCellWithReuseIdentifier: "TeamCollectionViewCell")
    }
    
    private func setActivityIndicatorView() {
        activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.hidesWhenStopped = true
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a team"
        navigationItem.searchController = searchController
    }
    
    private func setSubscriptions() {
        teamsManager.$result
            .sink(receiveValue: { [weak self] result in
                guard let self = self else { return }
                guard let teams = result?.data else { return }
                self.filtersVM.setFilteredTeams(from: teams)
            }).store(in: &subscriptions)
        teamsManager.$error.sink(receiveValue: { [weak self] error in
            guard let self = self else { return }
            guard let error = error else { return }
            
            let alert = UIAlertController(title: "☹️ \(error.message)", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
                self.teamsManager.get()
            }))
            
            self.present(alert, animated: true, completion: nil)
        })
        .store(in: &subscriptions)
        
        teamsManager.$isLoading.sink(receiveValue: { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.activityIndicatorView.startAnimating()
            } else {
                self.activityIndicatorView.stopAnimating()
            }
        })
        .store(in: &subscriptions)
        
        filtersVM.$filteredTeams.sink { [weak self] teams in
            self?.filteredTeams = teams
            self?.applySnapshot(animatingDifferences: true)
        }
        .store(in: &subscriptions)
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, team) ->
                UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "TeamCollectionViewCell",
                    for: indexPath) as? TeamCollectionViewCell
                cell?.teamVM = TeamViewModel(team: team)
                return cell
            })
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(filteredTeams)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TeamCollectionViewCell else { return }
        
        let destinationVC = DetailTeamViewController()
        destinationVC.teamPlayersVM = TeamPlayersViewModel(team: cell.teamVM.team)
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension ViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filtersVM.searchText = searchController.searchBar.text ?? ""
    }
}
