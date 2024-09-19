//
//  CreatureCell.swift
//  Fancy Cells
//
//  Created by Artur Akulich on 18.09.24.
//

import UIKit
import SnapKit

extension CreatureCell {
    enum CreatureType {
        case alive
        case dead
        case life
    }
    
    static func prepareCell(tableView: UITableView, indexPath: IndexPath, creatureType: CreatureType?) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Self.reuseID,
            for: indexPath
        ) as? Self,
              let creatureType else {
            return UITableViewCell()
        }
        cell.configure(type: creatureType)
        return cell
    }
}

final class CreatureCell: UITableViewCell {
    private enum Constants {
        enum Icon {
            static let alive = "💥"
            static let dead = "💀"
            static let life = "🐣"
        }
        
        enum Title {
            static let alive = "Живая"
            static let dead = "Мёртвая"
            static let life = "Жизнь"
        }
        
        enum Description {
            static let alive = "и шевелится!"
            static let dead = "или прикидывается"
            static let life = "Ку-ку!"
        }
        
        enum Gradient {
            static let alive = [
                CGColor(red: 255/255, green: 184/255, blue: 0/255, alpha: 1),
                CGColor(red: 255/255, green: 247/255, blue: 176/255, alpha: 1)
            ]
            static let dead = [
                CGColor(red: 13/255, green: 101/255, blue: 138/255, alpha: 1),
                CGColor(red: 176/255, green: 255/255, blue: 180/255, alpha: 1)
            ]
            static let life = [
                CGColor(red: 173/255, green: 0/255, blue: 255/255, alpha: 1),
                CGColor(red: 255/255, green: 176/255, blue: 233/255, alpha: 1)
            ]
        }
        
        enum Font {
            static let title: CGFloat = 20
            static let description: CGFloat = 14
        }
        
        enum Layout {
            static let spacing: CGFloat = 16
            static let cornerRaduis: CGFloat = 20
            static let iconSize: CGSize = .init(width: 40, height: 40)
        }
    }
    
    // MARK: - Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.Font.title, weight: .semibold)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.Font.description)
        return label
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constants.Font.title)
        return label
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        return gradient
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        gradientLayer.frame = emojiLabel.frame
        gradientLayer.cornerRadius = emojiLabel.layer.cornerRadius
    }
    
    // MARK: - Configuration
    private func configure(type: CreatureType) {
        switch type {
        case .alive:
            gradientLayer.colors = Constants.Gradient.alive
            titleLabel.text = Constants.Title.alive
            descriptionLabel.text = Constants.Description.alive
            emojiLabel.text = Constants.Icon.alive
        case .dead:
            gradientLayer.colors = Constants.Gradient.dead
            titleLabel.text = Constants.Title.dead
            descriptionLabel.text = Constants.Description.dead
            emojiLabel.text = Constants.Icon.dead
        case .life:
            gradientLayer.colors = Constants.Gradient.life
            titleLabel.text = Constants.Title.life
            descriptionLabel.text = Constants.Description.life
            emojiLabel.text = Constants.Icon.life
        }
    }
}

private extension CreatureCell {
    func setupView() {
        clipsToBounds = true
        contentView.layer.insertSublayer(gradientLayer, at: .zero)
        setupConstraints()
        
        emojiLabel.layer.cornerRadius = Constants.Layout.cornerRaduis
        emojiLabel.layer.masksToBounds = true
    }
    
    func setupConstraints() {
        contentView.addSubview(emojiLabel)
        emojiLabel.snp.makeConstraints { make in
            make.size.equalTo(Constants.Layout.iconSize)
            make.leading.verticalEdges.equalToSuperview().inset(Constants.Layout.spacing)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(emojiLabel.snp.trailing).offset(Constants.Layout.spacing)
            make.top.equalToSuperview().inset(Constants.Layout.spacing)
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(emojiLabel.snp.trailing).offset(Constants.Layout.spacing)
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }
}
