//
//  TeamsTableViewCell.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 28/2/21.
//

import UIKit
import Anchorage

class TeamsTableViewCell: UITableViewCell {

    var containerStackView = UIStackView()

    let nameLabel = UILabel()
    let desciprionLabel = UILabel()
    var images: [UIImageView] = []
    var team: Team?

    enum Constants {
        static let identifier = "TeamsTableViewCell"
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

    func bindTo(team: Team) {
        self.team = team
        nameLabel.text = team.name
        var pokemonsNames = ""

        for item in team.pokemons {
            let pokemonImage = UIImageView()
            if let url = item.imageUrl {
                pokemonImage.loadImageFrom(url: url)
            } else {
                pokemonImage.image = UIImage(named: "pokemon_placeholder")
            }
            images.append(pokemonImage)
            containerStackView.addArrangedSubview(pokemonImage)
            pokemonsNames += "\(item.name), "
        }
        desciprionLabel.text = "Este es un equipo formado por los pokemon \(pokemonsNames) uno de los mejores equipos formados por \(team.user.name)"
    }

    // Private
    override func prepareForReuse() {
        for item in images {
            item.removeFromSuperview()
        }
    }

    private func configure() {
        containerStackView.axis = .horizontal
        containerStackView.spacing = 8
        containerStackView.clipsToBounds = true
        containerStackView.distribution = .fillEqually
        desciprionLabel.numberOfLines = 0

        nameLabel.font = UIFont(name: "Montserrat-BoldItalic", size: 16)
        desciprionLabel.font = UIFont(name: "Montserrat-MediumItalic", size: 14)
    }

    private func buildInterface() {
        addSubview(containerStackView)
        addSubview(nameLabel)
        addSubview(desciprionLabel)
    }


    private func setUpDefaultLayout() {
        containerStackView.topAnchor == topAnchor
        containerStackView.widthAnchor == widthAnchor
        containerStackView.heightAnchor == heightAnchor * 0.6

        nameLabel.topAnchor == containerStackView.bottomAnchor + 12.0
        nameLabel.leadingAnchor == leadingAnchor + 20.0
        nameLabel.leadingAnchor == leadingAnchor + 20.0
        desciprionLabel.topAnchor == nameLabel.bottomAnchor
        desciprionLabel.leadingAnchor == leadingAnchor + 40.0
        desciprionLabel.trailingAnchor == trailingAnchor - 40.0
    }
}
