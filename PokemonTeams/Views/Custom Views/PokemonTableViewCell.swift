//
//  TeamSmallTableViewCell.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 28/2/21.
//

import UIKit
import Anchorage
import Combine

class PokemonTableViewCell: UITableViewCell {

    enum Constants {
        static let identifier = "TeamSmallTableViewCellId"
    }

    let stackView = UIStackView()
    let pokemonImage = UIImageView()
    let pokemonName = UILabel()
    var pokemon: Pokemon?
    
    func bindTo(pokemon: Pokemon) {
        self.pokemon = pokemon
        if let url = pokemon.imageUrl {
            pokemonImage.loadImageFrom(url: url)
        } else {
            // TODO Set Place Holder Image
        }

        pokemonName.text = pokemon.name
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        buildInterface()
        setUpDefaultLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK - Private

    private func configure() {
        stackView.axis = .horizontal
        stackView.spacing = 12

        pokemonName.textAlignment = .left
    }

    private func buildInterface() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(pokemonImage)
        stackView.addArrangedSubview(pokemonName)
    }

    private func setUpDefaultLayout() {
        stackView.edgeAnchors == edgeAnchors
        pokemonImage.widthAnchor == self.widthAnchor * 0.3
    }
}
