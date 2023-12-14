//
//  ViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 05.10.2023.
//

import UIKit
import SnapKit
import Firebase

final class HomeViewController: UIViewController {
    private let presenter: HomePresenter
    private var transactionData: [TransactionModel]?
    private let loader = UIActivityIndicatorView()
    private let loaderView = UIView()
    
    private let headerView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.shared.LightBrown
        view.layer.cornerRadius = 30
        view.layer.cornerCurve = .continuous
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    private let welcomeLabel: UILabel = {
        var label = UILabel()
        label.text = "Welcome Back,"
        label.font = UIFont.defaultFont(16)
        label.textColor = .darkGray
        return label
    }()
    
    private let userNameLabel: UILabel = {
        var label = UILabel()
        label.text = "Loading..."
        label.font = UIFont.defaultBoldFont(25)
        label.textColor = .darkGray
        return label
    }()
    
    private let card: UIView = {
        var card = UIView()
        card.backgroundColor = UIColor.shared.Brown
        card.layer.cornerRadius = 16
        card.layer.cornerCurve = .continuous
        card.clipsToBounds = true
        return card
    }()
    
    private let total: UILabel = {
        var label = UILabel()
        label.text = "Total Balance:"
        label.font = UIFont.defaultFont(20)
        label.textColor = .white
        return label
    }()
    
    private let totalLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.defaultBoldFont(35)
        label.textColor = .white
        return label
    }()
    
    //Income view
    private let incomeView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    
    private let income: UILabel = {
        var label = UILabel()
        label.text = "Income"
        label.textColor = .white
        label.font = UIFont.defaultFont(18)
        return label
    }()
    
    private let incomeImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(systemName: "square.and.arrow.down")
        image.tintColor = .white
        return image
    }()
    
    private let incomeLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.defaultFont(22)
        label.textColor = .white
        return label
    }()
    
    //Expense view
    private let expenseView: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let expense: UILabel = {
        var label = UILabel()
        label.text = "Expenses"
        label.font = UIFont.defaultFont(18)
        label.textColor = .white
        return label
    }()
    
    private let expenseImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(systemName: "square.and.arrow.up")
        image.tintColor = .white
        return image
    }()
    
    private let expenseLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.defaultFont(22)
        label.textColor = .white
        return label
    }()
    
    private lazy var transactionsTableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "TransactionTableViewCell")
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let transactionsLabel: UILabel = {
        var label = UILabel()
        label.text = "Transactions"
        label.font = UIFont.defaultBoldFont(18)
        label.textColor = .black
        return label
    }()
    
    private lazy var seeAllButton: UILabel = {
        var btn = UILabel()
        btn.text = "See All"
        btn.font = UIFont.defaultFont(17)
        btn.textColor = .black
        btn.isUserInteractionEnabled = true
        btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showAllTransactions)))
        return btn
    }()
    
    init(presenter: HomePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        presenter.viewDidLoaded()
        setupCardValues()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateView),
            name: Notification.Name("UpdateAfterTransaction"),
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc private func updateView() {
        presenter.updateView()
        
        presenter.calculateCardViewValues(data: transactionData)
    }
    
    @objc internal func showAllTransactions() {
        presenter.showAllTrasactionsTapped(data: transactionData!)
    }
    
    private func createFullTransactionViewController() -> UIViewController {
        let presenter = FullTransactionPresenter()
        let view = FullTransactionViewController(transactionData: self.transactionData!, presenter: presenter)
        presenter.view = view
        return view
    }
    
    private func setupCardValues() {
        presenter.calculateCardViewValues(data: transactionData)
    }
    
    deinit {
        print("HomeViewController was deinited")
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.35)
        }
        
        headerView.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        
        headerView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(2)
            make.leading.equalTo(welcomeLabel.snp.leading)
        }
        
        headerView.addSubview(card)
        card.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(userNameLabel.snp.bottom).offset(20)
            make.height.equalTo(view.snp.height).multipliedBy(0.25)
        }
        
        card.addSubview(total)
        total.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().inset(15)
        }
        
        card.addSubview(totalLabel)
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(total.snp.bottom).offset(5)
            make.leading.equalTo(total.snp.leading)
        }
        
        card.addSubview(incomeView)
        incomeView.snp.makeConstraints { make in
            make.leading.equalTo(totalLabel.snp.leading)
            make.bottom.equalToSuperview().offset(-15)
            make.height.equalTo(60)
            make.width.equalTo(card.snp.width).multipliedBy(0.4)
        }
        
        incomeView.addSubview(incomeImage)
        incomeImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(5)
            make.top.equalToSuperview().inset(5)
            make.size.equalTo(20)
        }
        
        incomeView.addSubview(income)
        income.snp.makeConstraints { make in
            make.leading.equalTo(incomeImage.snp.trailing).offset(5)
            make.top.equalToSuperview().inset(5)
        }
        
        incomeView.addSubview(incomeLabel)
        incomeLabel.snp.makeConstraints { make in
            make.leading.equalTo(incomeImage.snp.leading).offset(2)
            make.top.equalTo(incomeImage.snp.bottom).offset(5)
        }
        
        card.addSubview(expenseView)
        expenseView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
            make.height.equalTo(60)
            make.width.equalTo(card.snp.width).multipliedBy(0.4)
        }
        
        expenseView.addSubview(expenseImage)
        expenseImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(5)
            make.top.equalToSuperview().inset(5)
            make.size.equalTo(20)
        }
        
        expenseView.addSubview(expense)
        expense.snp.makeConstraints { make in
            make.leading.equalTo(expenseImage.snp.trailing).offset(5)
            make.top.equalToSuperview().inset(5)
        }
        
        expenseView.addSubview(expenseLabel)
        expenseLabel.snp.makeConstraints { make in
            make.leading.equalTo(expenseImage.snp.leading).offset(2)
            make.top.equalTo(expenseImage.snp.bottom).offset(5)
        }
        
        view.addSubview(transactionsLabel)
        transactionsLabel.snp.makeConstraints { make in
            make.leading.equalTo(card.snp.leading)
            make.top.equalTo(card.snp.bottom).offset(30)
        }
        
        view.addSubview(seeAllButton)
        seeAllButton.snp.makeConstraints { make in
            make.trailing.equalTo(card.snp.trailing)
            make.top.equalTo(transactionsLabel.snp.top)
        }
        
        view.addSubview(transactionsTableView)
        transactionsTableView.snp.makeConstraints { make in
            make.top.equalTo(transactionsLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(280)
        }
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transactionData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        cell.configure(transactionData: transactionData![indexPath.row])
        return cell
    }
}

extension HomeViewController: HomeViewProtocol {
    func updateCardViewValues(cardViewModel: CardViewModel) {
        incomeLabel.text = "$ \(cardViewModel.incomes)"
        expenseLabel.text = "$ \(cardViewModel.expenses)"
        totalLabel.text = "$ \(cardViewModel.total)"
    }
    
    func pushAllTransactionsView() {
        self.navigationController?.pushViewController(createFullTransactionViewController(), animated: true)
    }
    
    func showAbsenseDataAlert() {
        AlertManager.absenceTransactionData(on: self)
    }
    
    func setUsername(username: String) {
        self.userNameLabel.text = username
    }
    
    func updateTransactionsData(data: [TransactionModel]) {
        self.transactionData = data
        self.transactionsTableView.reloadData()
        self.setupCardValues()
    }
    
    func showLoader() {
        view.addSubview(loaderView)
        loaderView.backgroundColor = .white
        loaderView.frame = view.bounds
        loaderView.addSubview(loader)
        loader.startAnimating()
        loader.center = loaderView.center
    }
    
    func hideLoader() {
        loader.stopAnimating()
        loader.removeFromSuperview()
        loaderView.removeFromSuperview()
    }
}

