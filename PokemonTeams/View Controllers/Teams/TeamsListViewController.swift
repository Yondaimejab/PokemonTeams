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

    typealias TeamListDataSource = UITableViewDiffableDataSource<Sections, Team>

    enum Sections: Hashable {
        case main
    }


    // outlets
    @IBOutlet weak var tableView: UITableView!
    let addTeamButton = UIBarButtonItem()

    // Properties
    private var dataSource: TeamListDataSource!
    private var isEditingTeam: Bool = false

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

        dataSource = TeamListDataSource(tableView: tableView, cellProvider: { (tempTableView, indexPath, team) -> UITableViewCell? in
            guard let cell = tempTableView.dequeueReusableCell(withIdentifier: TeamsTableViewCell.Constants.identifier) as? TeamsTableViewCell else {
                fatalError("Could not dequeue TeamsTableViewCell")
            }
            cell.bindTo(team: team)
            return cell
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.createSegueIdentifier {
            if let destinationVC = segue.destination as? CreateTeamsViewController {
                destinationVC.isEditingTeams = true
            }
        }
    }
}

extension TeamsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height * 0.5
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let editAction = UIContextualAction(style: .normal, title: "Editar") { (action, view, completion) in
            // TODO
            self.isEditingTeam = true
        }

        let deleteAction = UIContextualAction(style: .destructive, title: "Eliminar") { (action, view, completion) in
            // TODO
        }

        return UISwipeActionsConfiguration(actions: [editAction, deleteAction])
    }
}
