//
//  TeamsListViewController.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 28/2/21.
//

import UIKit
import Combine

class TeamsListViewController: UIViewController {
    enum Constants {
        static let createSegueIdentifier = "createPokemonTeamSegue"
    }

    // typealias TeamListDataSource = UITableViewDiffableDataSource<Sections, Team>

    enum Sections: Hashable {
        case main
    }


    // outlets
    @IBOutlet weak var tableView: UITableView!
    let addTeamButton = UIBarButtonItem()

    // Properties
    private var dataSource: TeamListDataSource!
    private var isEditingTeam: Bool = false
    private var teamToEdit: Team?
    private var teamsSubscriber: AnyCancellable?
    private var listViewModel = TeamListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView() {
        addTeamButton.image = UIImage(systemName: "plus")
        addTeamButton.action = #selector(goToCreateTeam)
        addTeamButton.target = self
        addTeamButton.title = "Crear"
        navigationItem.rightBarButtonItem = addTeamButton

        setupTableView()
    }

    @objc func goToCreateTeam() {
        performSegue(withIdentifier: Constants.createSegueIdentifier, sender: self)
    }

    private func setupTableView() {
        tableView.register(TeamsTableViewCell.self, forCellReuseIdentifier: TeamsTableViewCell.Constants.identifier)

        tableView.delegate = self

        tableView.dataSource = dataSource

        dataSource = TeamListDataSource(tableView: tableView, cellProvider: { (tempTableView, indexPath, team) -> UITableViewCell? in
            guard let cell = tempTableView.dequeueReusableCell(withIdentifier: TeamsTableViewCell.Constants.identifier) as? TeamsTableViewCell else {
                fatalError("Could not dequeue TeamsTableViewCell")
            }
            cell.bindTo(team: team)
            return cell
        })

        teamsSubscriber = listViewModel.$listOfPokemonTeams.sink(receiveValue: { (pokemonTeams) in
            self.updateSnapshot(with: pokemonTeams)
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let keychain = Keychain()
        if let userData = keychain.getData(for: Keychain.Constants.userKey) {
            if let user = try? JSONDecoder().decode(User.self, from: userData) {
                listViewModel.listTeams(for: user)
            }
        }
    }

    private func updateSnapshot(with pokemonTeams: [Team]) {
        var snapshot = NSDiffableDataSourceSnapshot<Sections, Team>()
        snapshot.appendSections([.main])
        snapshot.appendItems(pokemonTeams, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.createSegueIdentifier {
            if let destinationVC = segue.destination as? CreateTeamsViewController {
                destinationVC.isEditingTeams = self.isEditingTeam
                destinationVC.team = teamToEdit
            }
        }
    }
}

extension TeamsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height * 0.5
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath) as? TeamsTableViewCell else { return nil }
        guard let team = cell.team else {return nil}

        let editAction = UIContextualAction(style: .normal, title: "Editar") { (action, view, completion) in
            self.isEditingTeam = true
            self.teamToEdit = team
            self.performSegue(withIdentifier: Constants.createSegueIdentifier, sender: self)
        }

        let deleteAction = UIContextualAction(style: .destructive, title: "Eliminar") { (action, view, completion) in
            self.listViewModel.deleteTeam(team: team)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}

// This custom class is made so that swipeActions Work with diffable Datasource
class TeamListDataSource: UITableViewDiffableDataSource<TeamsListViewController.Sections, Team> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
