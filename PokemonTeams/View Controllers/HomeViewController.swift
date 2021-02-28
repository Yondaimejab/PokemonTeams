//
//  HomeViewController.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 27/2/21.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    typealias PokemonDataSource = UICollectionViewDiffableDataSource<Section, Pokemon>

    enum Section {
        case main
    }

    // Constants
    enum Constants {
        static let estimatedRowHeight: CGFloat = 80.0
    }

    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    // Properties
    var dataSource: PokemonDataSource!
    var homeViewModel = HomeViewModel()
    var pokemonSubscriber: AnyCancellable?
    var actvityIndicator = UIRefreshControl()
    var shouldRefreshPokemons = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }

    private func setupView() {

        setupCollectionView()

        pokemonSubscriber = homeViewModel.$pokemons.receive(on: RunLoop.main).sink { [weak self] (pokemonList) in
            guard let self = self else {return}
            self.updateDataSource(with: pokemonList)
            // TODO: remove activity indicator when active
        }

        // TODO: add activity indicator
        getNextPokemons()
        collectionView.refreshControl = actvityIndicator
        collectionView.delegate = self
    }

    func getNextPokemons() {
        homeViewModel.getNextPokemons()
    }

    func getPreviusPokemos() -> Bool {
        return homeViewModel.getPreviusPokemons()
    }

    private func setupCollectionView() {
        // register Cells
        collectionView.register(
            PokemonCollectionViewCell.self,
            forCellWithReuseIdentifier: PokemonCollectionViewCell.Constants.cellIdentifier
        )

        dataSource = PokemonDataSource(collectionView: collectionView, cellProvider: { (pokemonCollectionView, indexPath, pokemon) -> UICollectionViewCell? in
            let cellConfiguration = UICollectionView.CellRegistration<PokemonCollectionViewCell, Pokemon> {
                cell, indexPath, item in
                cell.bindto(pokemon: item)
            }

            let cell = pokemonCollectionView.dequeueConfiguredReusableCell(using: cellConfiguration, for: indexPath, item: pokemon)
            return cell
        })

        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createCollectionViewLayout()
    }

    private func updateDataSource(with pokemonList: [Pokemon]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Pokemon>()
        snapShot.appendSections([.main])
        snapShot.appendItems(pokemonList, toSection: .main)
        dataSource.apply(snapShot, animatingDifferences: true) {
            self.shouldRefreshPokemons = true
            self.actvityIndicator.endRefreshing()
        }
    }

    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout {
            (sectionNumber, env) -> NSCollectionLayoutSection? in

            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.3)), subitem: item, count: 2)

            group.contentInsets.bottom = 12

            let section = NSCollectionLayoutSection(group: group)
            return section

        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset

        if distanceFromBottom < height {
            if shouldRefreshPokemons {
                shouldRefreshPokemons = false
                self.getNextPokemons()
                actvityIndicator.beginRefreshing()
            }
        } else if contentYoffset < -100 {
            if shouldRefreshPokemons {
                shouldRefreshPokemons = false
                if self.getPreviusPokemos() {
                    actvityIndicator.beginRefreshing()
                    shouldRefreshPokemons = true
                }
            }
        }
    }
}