//
//  DetailTeamViewController.swift
//  NBA Test
//
//  Created by Marco Falanga on 17/02/21.
//

import UIKit
import Combine

/// Pushed when you tap on a team cell. It shows the team details and the team players. If you tap on a player cell it presents a DetailPlayerViewController.
///
/// The subviews are:
/// - activityIndicatorView: which appears during the url data task
/// - tableView: that shows the list of players (its header shows the team info)
/// - noPlayersLabel: which appears when the tableView numberOfRows is zero
///
/// It sets the team players from the PlayersViewModel singleton. It loads more players when scrolling down or if players are not enough.
/// If you tap on a player cell it presents the DetailPlayerViewController using a custom transition (see CardAnimator).
class DetailTeamViewController: UIViewController {
    
    var teamPlayersVM: TeamPlayersViewModel!

    // I want to load more items even when you do not scroll down but the current
    // players in this team are not enough
    private let minNumberOfPlayers = 15
    // boolean to handle pagination when scrolling
    private var isLoading = false

    private var tableView: UITableView!
    private var activityIndicatorView: UIActivityIndicatorView!
    private var noPlayersLabel: UILabel!
    private var subscriptions: Set<AnyCancellable> = []

    private var cardAnimator: CardAnimator?

    var teamPlayerVMs: [PlayerViewModel] = [] {
        didSet {
            if teamPlayerVMs.count < minNumberOfPlayers, PlayersViewModel.shared.isFull == false {
                PlayersViewModel.shared.get()
            }
            
            tableView.reloadData()
            #if DEBUG
            self.reloadData?(teamPlayerVMs)
            #endif
        }
    }
        
    #if DEBUG
    var reloadData: (([PlayerViewModel])->Void)?
    #endif

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        teamPlayersVM.setPlayers(allPlayers: PlayersViewModel.shared.players)
        
        setTableView()
        setActivityIndicatorView()
        setNoPlayersLabel()
        setSubscriptions()
        
        self.navigationItem.title = teamPlayersVM.team.name
    }
    
    private func setTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(PlayerTableViewCell.self, forCellReuseIdentifier: "playerCellID")
        tableView.register(TeamInfoHeaderView.self, forHeaderFooterViewReuseIdentifier: "headerID")        
    }
    
    private func setActivityIndicatorView() {
        activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.hidesWhenStopped = true
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setNoPlayersLabel() {
        noPlayersLabel = UILabel(frame: .zero)
        noPlayersLabel.text = "There are no players associated with this team"
        noPlayersLabel.numberOfLines = 0
        noPlayersLabel.textColor = .secondaryLabel
        noPlayersLabel.textAlignment = .center

        view.addSubview(noPlayersLabel)
        noPlayersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noPlayersLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noPlayersLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -20).isActive = true

        noPlayersLabel.translatesAutoresizingMaskIntoConstraints = false
        noPlayersLabel.isHidden = true
    }
    
    private func setSubscriptions() {
        PlayersViewModel.shared.$players
            .sink(receiveValue: { [weak self] players in
                guard let self = self else { return }
                self.teamPlayersVM.setPlayers(allPlayers: players)
            }).store(in: &subscriptions)
        
        teamPlayersVM.$teamPlayers.sink(receiveValue: { [weak self] players in
            guard let self = self else { return }
            self.teamPlayerVMs = players.map { PlayerViewModel(player: $0) }
            
            if players.isEmpty {
                self.noPlayersLabel.isHidden = false
            } else {
                self.noPlayersLabel.isHidden = true
            }
        }).store(in: &subscriptions)
        
        PlayersViewModel.shared.$error.sink(receiveValue: { [weak self] error in
            guard let self = self else { return }
            guard let error = error else { return }
            
            let alert = UIAlertController(title: "☹️ \(error.message)", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
                PlayersViewModel.shared.get()
            }))
            
            self.present(alert, animated: true, completion: nil)
        })
        .store(in: &subscriptions)
        
        PlayersViewModel.shared.$isLoading.sink(receiveValue: { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.activityIndicatorView.startAnimating()
            } else {
                self.activityIndicatorView.stopAnimating()
            }
        })
        .store(in: &subscriptions)
    }
}

extension DetailTeamViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        cardAnimator = CardAnimator(mode: .present, duration: 0.4)
        return cardAnimator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        cardAnimator = CardAnimator(mode: .dismiss, duration: 0.4)
        return cardAnimator
    }
}


extension DetailTeamViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if PlayersViewModel.shared.isLoading == false, isLoading {
                isLoading = false
                PlayersViewModel.shared.get()
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isLoading = true
    }
}
