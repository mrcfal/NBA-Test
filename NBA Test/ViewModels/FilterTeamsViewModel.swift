//
//  FilterTeamsViewModel.swift
//  NBA Test
//
//  Created by Marco Falanga on 17/02/21.
//

import Foundation
import Combine

/// Used to filter teams based on the segmentControl (by conference) and/or the search bar (by name).
///
/// When the conference value and/or the searchText value changes, the publisher is received and it calls **setFilters**, which updates filteredTeams based on the active filters.
///
/// Filters work only when allTeams is set. You should call setFilteredTeams when the class responsible for fetching the teams succeeds (TeamsViewModel).
///
/// Extra:
/// - I created this class which depends on TeamsViewModel (due to the allTeams information) as a new class in order to split responsibility with TeamsViewModel;
/// - The filteredTeams could also be a computed property but it has performances issues and it is not the preferred choise if we want to move to SwiftUI in the future (also it cannot be published if it computed, even though we can use the conference/searchText published properties to trigger the UI update).
final class FilterTeamsViewModel: ObservableObject {
    @Published private(set) var filteredTeams: [TeamModel] = []
    @Published var conference: ConferenceType = .all
    @Published var searchText: String = ""
    private var allTeams: [TeamModel] = []
    private var subscriptions: Set<AnyCancellable> = []
    
    init() {
        Publishers.CombineLatest($conference, $searchText)
            .receive(on: RunLoop.main)
            .sink { [weak self] (conference, searchText) in
                self?.setFilters()
            }
            .store(in: &subscriptions)
    }
    
    func setFilteredTeams(from teams: [TeamModel]) {
        self.allTeams = teams
        self.setFilters()
    }
    
    func setFilters() {
        var array = [TeamModel]()
        switch conference {
        case .all:
            array = allTeams
        default:
            array = allTeams.filter { TeamViewModel(team: $0).conference == conference }
        }
        
        if searchText.isEmpty {
            filteredTeams = array
        } else {
            filteredTeams = array.filter { $0.fullName.contains(searchText) }
        }
    }
}
