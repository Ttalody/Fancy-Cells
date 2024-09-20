//
//  MainViewController.swift
//  Fancy Cells
//
//  Created by Artur Akulich on 18.09.24.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    private enum Constants {
        enum Gradient {
            static let tableView = [
                CGColor(red: 49/255, green: 0/255, blue: 80/255, alpha: 1),
                CGColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            ]
        }
        
        enum Layout {
            static let spacing: CGFloat = 16
            static let cornerRadius: CGFloat = 8
            static let headerHeight: CGFloat = 80
        }
        
        enum Color {
            static let buttonColor: UIColor = UIColor(red: 90/255, green: 52/255, blue: 114/255, alpha: 1)
        }
        
        enum Strings {
            static let create = "Сотворить"
            static let cellsList = "Клеточное наполнение"
        }
    }
    
    // MARK: - Properties
    private var model: MainModel
    
    // MARK: - Components
    private lazy var creaturesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CreatureCell.self, forCellReuseIdentifier: CreatureCell.reuseID)
        return tableView
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.Strings.create, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.tintColor = .white
        button.layer.cornerRadius = Constants.Layout.cornerRadius
        button.backgroundColor = Constants.Color.buttonColor
        button.addTarget(self, action: #selector(createCell), for: .touchUpInside)
        return button
    }()
    
    private lazy var headerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.text = Constants.Strings.cellsList
        label.backgroundColor = .clear
        label.frame = label.frame.inset(
            by: UIEdgeInsets(
                top: Constants.Layout.spacing,
                left: .zero,
                bottom: Constants.Layout.spacing,
                right: .zero
            )
        )
        return label
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = Constants.Gradient.tableView
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        return gradientLayer
    }()
    
    // MARK: - Init
    init(model: MainModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        CreatureCell.prepareCell(
            tableView: tableView,
            indexPath: indexPath,
            creatureType: model.cells[indexPath.row]
        )
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constants.Layout.headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerTitleLabel
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Private functions
private extension MainViewController {
    func setupView() {
        view.layer.insertSublayer(gradientLayer, at: .zero)
        setupCreateButton()
        setupTableView()
        
        bind()
    }
    
    func setupTableView() {
        view.addSubview(creaturesTableView)
        creaturesTableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(createButton.snp.top).offset(-Constants.Layout.spacing)
        }
        creaturesTableView.backgroundColor = .clear
    }
    
    func setupCreateButton() {
        view.addSubview(createButton)
        createButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constants.Layout.spacing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(Constants.Layout.spacing)
        }
    }
    
    func bind() {
        model.onCreation = { [weak self] newCell in
            DispatchQueue.main.async {
                self?.creaturesTableView.reloadData()
            }
        }
    }
    
    @objc
    func createCell() {
        model.createCell()
    }
}
