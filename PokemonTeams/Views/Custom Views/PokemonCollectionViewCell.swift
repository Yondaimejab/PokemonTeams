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
    var pokemon: Pokemon?

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
        self.pokemonImageView.loadImageFrom(url: pokemon.imageUrl)
        self.addShadowToImage()
    }

    // Private
    private func configure() {
        self.backgroundColor = .white
        self.cornerRadius = 10
        self.pokemonImageView.cornerRadius = 10
        self.pokemonImageView.layer.masksToBounds = true
        self.pokemonNameLabel.textAlignment = .center
        self.pokemonNameLabel.font = UIFont(name: "Montserrat-MediumItalic", size: 14)
        pokemonNameLabel.font = .systemFont(ofSize: 16)
    }

    private func buildInterface() {
        self.addSubview(pokemonImageView)
        self.addSubview(pokemonNameLabel)
    }

    private func setupDefaultLayout() {
        pokemonImageView.centerXAnchor == self.centerXAnchor
        pokemonImageView.centerYAnchor == self.centerYAnchor
        pokemonImageView.heightAnchor == self.heightAnchor * 0.6

        pokemonNameLabel.topAnchor == self.topAnchor
        pokemonNameLabel.leadingAnchor == self.leadingAnchor + Constants.horizontalMargin
        pokemonNameLabel.trailingAnchor == self.trailingAnchor - Constants.horizontalMargin
        pokemonNameLabel.heightAnchor == 12.0
    }

    func addShadowToImage() {
        let width: CGFloat = 200
        let heght: CGFloat = 200
        let shadowSize: CGFloat = 20
        let contactRect = CGRect(x: -shadowSize, y: heght - (shadowSize * 0.4), width: width + shadowSize * 2, height: shadowSize)
        pokemonImageView.layer.shadowColor = UIColor.black.cgColor
        pokemonImageView.layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
        pokemonImageView.layer.shadowRadius = 5
        pokemonImageView.layer.shadowOpacity = 1
        pokemonImageView.layer.masksToBounds = true
    }
}

