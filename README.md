# NBA Test

iOS demo app written in **Swift 5**, using *UIKit* and *Combine*.

## Description

The app shows the NBA teams (**ViewController**). You can filter the results by name and/or by conference. 

If you select a team, the navigation controller pushes a new view controller (**DetailTeamViewController**) showing the team info and the team players.

When selecting a player the view controller presents the third view controller (**DetailPlayerViewController**), with the player, using a transition with the style of a popup.

## URL Requests

- [RapidAPI](https://rapidapi.com/theapiguy/api/free-nba/endpoints) - used to fetch the list of teams `/teams` and the list of all players `/players`; 
- [NBA website](https://www.nba.com/.element/img/1.0/teamsites/logos/teamlogos_500x500/atl.png) - used to fetch the teams' logos.

###### 1. RapidAPI does not provide a web service that returns the players given a specific team. You can read below how it effected the app architecture. 
###### 2. `/players` implements pagination.

## Architecture
![NBA Test Architecture]("nba_arch.png")

### Extra
- Dark Mode
- Portrait/Landscape orientation support

### Discussion

Using the `PlayersViewModel.shared` **singleton** provides the following benefits:

1. global information about **all the fetched players**, so that you can filter them by team to display the right list for each team;
1. keeping track of the current page, so that every time a DetailTeamVC asks the singleton to fetch the next page, it is actually providing the information to all the possibile selected teams;
1. keeping track of the `isFull` boolean information, that indicates when all the players have been fetched.

The reason why PlayersViewModel is implemented as a singleton is related to the fact that there is no web service that provides players for a specific team. This way, every time a DetailTeamViewController is pushed to the navigation stack, it contributes to keep loading new players for every possible selected team.
