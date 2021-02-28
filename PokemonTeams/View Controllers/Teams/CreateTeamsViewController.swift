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
    typealias PokemonDataSource = UITableViewDiffableDataSource<Sections, Pokemon>

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


    // Properties
    var isEditingTeams = false
    private var searchResultTableView = UITableView()
    private var searchSubscriber: AnyCancellable?
    private var createViewModel = CreateTeamViewModel()
    private var selectedTeamDataSource: PokemonDataSource!
    private var searchPokemonDataSource: PokemonDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        let magnifyingglass = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        pokemonSearchTextField.rightView = magnifyingglass
        pokemonSearchTextField.addSubview(magnifyingglass)
        // Do any additional setup after loading the view.

        searchSubscriber = pokemonSearchTextField.publisher(for: \.text)
            .didChange().debounce(for: .seconds(3), scheduler: DispatchQueue.main)
            .sink { (_) in
            // Send searchEvent
            }

        self.view.addSubview(searchResultTableView)
        searchResultTableView.isHidden = true
        searchResultTableView.topAnchor == pokemonSearchTextField.bottomAnchor + 12
        searchResultTableView.leadingAnchor == self.view.leadingAnchor + 20
        searchResultTableView.trailingAnchor == self.view.trailingAnchor - 20
        setupTableView()
    }

    private func setupTableView() {

        // Register UItableViewCell for teams
        addedPokemonsTableView.dataSource = selectedTeamDataSource

        selectedTeamDataSource = PokemonDataSource(tableView: searchResultTableView, cellProvider: { (tableView, indexPAth, pokemon) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "asdasd") else {
                fatalError("Could not dequeue cell")
            }

            return cell
        })

        // register cell for tableView
        searchResultTableView.dataSource = searchPokemonDataSource
        searchPokemonDataSource = PokemonDataSource(tableView: searchResultTableView, cellProvider: { (tableView, indexPAth, pokemon) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "asdasd") else {
                fatalError("Could not dequeue cell")
            }

            return cell
        })
    }

    private func updateDataSourceForSelectedPokemons(list: [Pokemon]) {
        var snapshot = NSDiffableDataSourceSnapshot<Sections, Pokemon>()
        snapshot.appendSections([.main])
        snapshot.appendItems(list, toSection: .main)
        selectedTeamDataSource.apply(snapshot)
    }

    private func updateDataSourceForSearchResults(list: [Pokemon]) {
        var snapshot = NSDiffableDataSourceSnapshot<Sections, Pokemon>()
        snapshot.appendSections([.main])
        snapshot.appendItems(list, toSection: .main)
        searchPokemonDataSource.apply(snapshot)
    }

    func toggleSearchResultsActive(isActive: Bool) {
        searchResultTableView.isHidden = !isActive
        searchResultTableView.contentSize.height = isActive ? (3.0 * Constants.pokemonSearchResultCellHeight) : 0.0
    }
}
