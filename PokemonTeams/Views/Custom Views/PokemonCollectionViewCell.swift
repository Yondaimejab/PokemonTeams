//
//  PokemonCollectionViewCell.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 27/2/21.
//

import UIKit
import Anchorage

class PokemonCollectionViewCell: UICollectionViewCell {
    // Constants
    enum Constants {
        static let cellIdentifier = "PokemonCellIdentifier"
        static let horizontalMargin = 10.0
    }

    let pokemonImageView = UIImageView()
    let pokemonNameLabel = UILabel()
    let pokemonDescripcion = UILabel()
    let stackview = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        buildInterface()
        setupDefaultLayout()
    }

    override func prepareForReuse() {
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindto(pokemon: Pokemon) {
        self.pokemonNameLabel.text = pokemon.name
        self.pokemonDescripcion.text = pokemon.description
        self.pokemonImageView.loadImageFrom(url: pokemon.imageURL)
    }

    // Private
    private func configure() {
        self.backgroundColor = .white
        self.cornerRadius = 10
        self.pokemonImageView.cornerRadius = 10
        self.pokemonImageView.layer.masksToBounds = true
        self.pokemonDescripcion.numberOfLines = 3
        self.pokemonDescripcion.lineBreakMode = .byTruncatingTail
        pokemonNameLabel.font = .systemFont(ofSize: 16)
        pokemonDescripcion.font = .systemFont(ofSize: 12)
        pokemonDescripcion.textColor = .lightGray
        stackview.axis = .vertical
        stackview.spacing = 10
    }

    private func buildInterface() {
        self.addSubview(pokemonImageView)
        self.addSubview(stackview)
        stackview.addArrangedSubview(pokemonNameLabel)
        stackview.addArrangedSubview(pokemonDescripcion)
    }

    private func setupDefaultLayout() {
        pokemonImageView.bottomAnchor == self.centerYAnchor
        pokemonImageView.centerXAnchor == self.centerXAnchor
        pokemonImageView.heightAnchor == self.heightAnchor * 0.5

        stackview.topAnchor == pokemonImageView.bottomAnchor + 8
        stackview.leadingAnchor == self.leadingAnchor + Constants.horizontalMargin
        stackview.trailingAnchor == self.trailingAnchor - Constants.horizontalMargin
        stackview.bottomAnchor == self.bottomAnchor - 8
        pokemonNameLabel.heightAnchor == 12.0
    }
}
