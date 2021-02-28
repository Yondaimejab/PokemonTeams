//
//  TeamsTableViewCell.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 28/2/21.
//

import UIKit
import Anchorage

class TeamsTableViewCell: UITableViewCell {

    let containerStackView = UIStackView()
    let mainImage = UIImageView()
    let secundaryImageStackView = UIStackView()
    let thirdImageStackView = UIStackView()
    let lastImageStackView = UIStackView()

    let nameLabel = UILabel()
    let desciprionLabel = UILabel()

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
        // TODO Bind teams to cell
    }

    // Private

    private func configure() {
        containerStackView.axis = .horizontal
        containerStackView.spacing = 8
        secundaryImageStackView.axis = .vertical
        secundaryImageStackView.spacing = 8
        thirdImageStackView.spacing = 8
        thirdImageStackView.axis = .horizontal
        lastImageStackView.spacing = 8
        lastImageStackView.axis = .horizontal
        containerStackView.clipsToBounds = true

    }

    private func buildInterface() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(mainImage)
        containerStackView.addArrangedSubview(secundaryImageStackView)
        secundaryImageStackView.addArrangedSubview(thirdImageStackView)
        secundaryImageStackView.addArrangedSubview(lastImageStackView)
    }


    private func setUpDefaultLayout() {
        containerStackView.topAnchor == topAnchor
        containerStackView.widthAnchor == widthAnchor
        containerStackView.heightAnchor == heightAnchor * 0.6

        nameLabel.topAnchor == containerStackView.bottomAnchor + 12.0
        nameLabel.leadingAnchor == leadingAnchor + 20.0
        nameLabel.leadingAnchor == leadingAnchor + 20.0
        desciprionLabel.topAnchor == nameLabel.bottomAnchor
        desciprionLabel.leadingAnchor == leadingAnchor + 20.0
        desciprionLabel.trailingAnchor == trailingAnchor + 20.0
    }
}
