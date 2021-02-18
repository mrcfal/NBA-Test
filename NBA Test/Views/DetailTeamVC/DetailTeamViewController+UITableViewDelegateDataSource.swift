//
//  DetailTeamViewController+UITableViewDelegateDataSource.swift
//  NBA Test
//
//  Created by Marco Falanga on 18/02/21.
//

import SwiftUI

extension DetailTeamViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamPlayerVMs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "playerCellID") as? PlayerTableViewCell else { return UITableViewCell() }
        
        cell.playerVM = teamPlayerVMs[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerID") as? TeamInfoHeaderView else { return nil }
        
        headerView.teamInfoVM = TeamInfoViewModel(team: teamPlayersVM.team)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? PlayerTableViewCell else { return }
        
        let destinationVC = DetailPlayerViewController()
        destinationVC.playerInfoVM = PlayerInfoViewModel(player: cell.playerVM.player)
        destinationVC.transitioningDelegate = self
        self.present(destinationVC, animated: true, completion: nil)
    }
}
