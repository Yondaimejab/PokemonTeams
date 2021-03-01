//
//  CreateTeamsViewController.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 28/2/21.
//

import UIKit
import Anchorage
import Combine

class CreateTeamsViewController: UIViewController {
    typealias TeamsDataSource = UITableViewDiffableDataSource<Sections, Team>
    // typealias PokemonDataSource = UITableViewDiffableDataSource<Sections, Pokemon>

    enum Sections {
        case main
    }

    // Constants
    enum Constants {
        static let pokemonSearchResultCellHeight: CGFloat = 50.0
        static let pokemonSelectedTeamCellHeight: CGFloat = 80.0
    }

    // Outlets
    @IBOutlet weak var teamNameLabel: UITextField!
    @IBOutlet weak var pokemonSearchTextField: UITextField!
    @IBOutlet weak var addedPokemonsTableView: UITableView!
    @IBOutlet weak var saveTeamButton: UIButton!
    @IBOutlet weak var addPokemonButton: UIButton!


    // Properties
    var isEditingTeams = false
    private var createViewModel = CreateTeamViewModel()
    private var selectedTeamDataSource: PokemonDataSource!
    private var saveButtonEnableSubscriber: AnyCancellable?
    private var pokemonListSubscriber: AnyCancellable?

    var team: Team?

    override func viewDidLoad() {
        super.viewDidLoad()
        let magnifyingglass = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        pokemonSearchTextField.rightView = magnifyingglass
        pokemonSearchTextField.addSubview(magnifyingglass)
        // Do any additional setup after loading the view.

        pokemonSearchTextField.delegate = self

        setupTableView()
        subscribeToViewItems()
    }

    private func subscribeToViewItems() {
        saveButtonEnableSubscriber = createViewModel.$selectedPokemonsForTeam
            .sink { [weak self] (pokemonsInTeam) in
                guard let self = self else {return}
                guard let labelText = self.teamNameLabel.text, labelText.isEmpty == false else {return self.disableSaveTeamButton()}
                guard pokemonsInTeam.count >= 3 else { return self.disableSaveTeamButton() }
                self.enableSaveTeamButton()

                if pokemonsInTeam.count == 6 {
                    self.addPokemonButton.isEnabled = false
                    UIView.animate(withDuration: 1.0) {
                        self.addPokemonButton.layer.opacity = 0.4
                    }
                } else if pokemonsInTeam.count < 6, !self.addPokemonButton.isEnabled {
                    self.addPokemonButton.isEnabled = true
                    UIView.animate(withDuration: 1.0) {
                        self.addPokemonButton.layer.opacity = 1.0
                    }
                }
            }
    }

    func disableSaveTeamButton() {
        guard saveTeamButton.isEnabled else {return}
        saveTeamButton.isEnabled = false
        UIView.animate(withDuration: 1.5) {
            self.saveTeamButton.layer.opacity = 0.4
        }
    }

    func enableSaveTeamButton() {
        guard !saveTeamButton.isEnabled else {return}
        saveTeamButton.isEnabled = true
        UIView.animate(withDuration: 1.0) {
        self.saveTeamButton.layer.opacity = 1
        }
    }

    private func setupTableView() {

        addedPokemonsTableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: PokemonTableViewCell.Constants.identifier)
        addedPokemonsTableView.dataSource = selectedTeamDataSource
        addedPokemonsTableView.rowHeight = 70.0

        addedPokemonsTableView.delegate = self
        selectedTeamDataSource = PokemonDataSource(tableView: addedPokemonsTableView, cellProvider: { (tableView, indexPAth, pokemon) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonTableViewCell.Constants.identifier) as? PokemonTableViewCell else {
                fatalError("Could not dequeue cell")
            }

            cell.bindTo(pokemon: pokemon)

            return cell
        })

        pokemonListSubscriber = createViewModel.$selectedPokemonsForTeam.sink(receiveValue: { [weak self] (pokemonList) in
            self?.updateDataSourceForSelectedPokemons(list: pokemonList)
        })

        if isEditingTeams, let teamToEdit = team {
            teamNameLabel.text = teamToEdit.name
            createViewModel.selectedPokemonsForTeam.append(contentsOf: teamToEdit.pokemons)
        }
    }

    private func updateDataSourceForSelectedPokemons(list: [Pokemon]) {
        var snapshot = NSDiffableDataSourceSnapshot<Sections, Pokemon>()
        snapshot.appendSections([.main])
        snapshot.appendItems(list, toSection: .main)
        selectedTeamDataSource.apply(snapshot)
    }

    @IBAction func addPokemon(_ sender: Any) {
        guard let pokemonName = pokemonSearchTextField.text, pokemonName.isEmpty == false  else {
            return
        }
        createViewModel.searchPokemon(with: pokemonName)
    }

    @IBAction func saveTeam(_ sender: Any) {
        if isEditingTeams {
            guard let teamToUpdate = team else {return}
            createViewModel.update(teamId: teamToUpdate.id, with: teamNameLabel.text ?? "", user: teamToUpdate.user.id)
        } else {
            let keychain = Keychain()
            if let data = keychain.getData(for: Keychain.Constants.userKey) {
                if let user = try? JSONDecoder().decode(User.self, from: data) {
                    createViewModel.createTeam(with: teamNameLabel.text ?? "", user: user.id)
                }
            }
        }
    }
}

extension CreateTeamsViewController: UITextFieldDelegate, UITableViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let pokemonName = textField.text, pokemonName.isEmpty == false  else {
            return true
        }
        createViewModel.searchPokemon(with: pokemonName)
        return true
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       return UISwipeActionsConfiguration(actions: [UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, completion) in
            guard let cell = tableView.cellForRow(at: indexPath) as? PokemonTableViewCell else {return}
            if let pokemon = cell.pokemon {
                self.createViewModel.selectedPokemonsForTeam.removeAll(where: ({ $0 == pokemon}))
            }
            completion(true)
        })])
    }
}


// This custom class is made so that swipeActions Work with diffable Datasource
class PokemonDataSource: UITableViewDiffableDataSource<CreateTeamsViewController.Sections, Pokemon> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
