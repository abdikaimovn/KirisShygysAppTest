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
    var transactionDataArray: [TransactionModel]?
    private let loader = UIActivityIndicatorView()
    private let loaderView = UIView()
    
    private var headerView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(hex: "#ddd0bb")
        view.layer.cornerRadius = 30
        view.layer.cornerCurve = .continuous
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    private var welcomeLabel: UILabel = {
        var label = UILabel()
        label.text = "Welcome Back,"
        label.font = UIFont(name: "Futura", size: 16)
        label.textColor = .darkGray
        return label
    }()
    
    private var userNameLabel: UILabel = {
        var label = UILabel()
        label.text = "Loading..."
        label.font = UIFont(name: "Futura-CondensedExtraBold", size: 25)
        label.textColor = .darkGray
        return label
    }()
    
    private var card: UIView = {
        var card = UIView()
        card.backgroundColor = UIColor.shared.Brown
        card.layer.cornerRadius = 16
        card.layer.cornerCurve = .continuous
        card.clipsToBounds = true
        return card
    }()
    
    private var total: UILabel = {
        var label = UILabel()
        label.text = "Total Balance:"
        label.font = UIFont(name: "Futura", size: 20)
        label.textColor = .white
        return label
    }()
    
    private var totalBalance: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "Futura-Bold", size: 35)
        label.textColor = .white
        return label
    }()
    
    //Income view
    private var incomeView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    
    private var income: UILabel = {
        var label = UILabel()
        label.text = "Income"
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 18)
        return label
    }()
    
    private var incomeImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(systemName: "square.and.arrow.down")
        image.tintColor = .white
        return image
    }()
    
    private var incomeLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "Futura", size: 22)
        label.textColor = .white
        return label
    }()
    
    //Expense view
    private var expenseView: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private var expense: UILabel = {
        var label = UILabel()
        label.text = "Expenses"
        label.font = UIFont(name: "Futura", size: 18)
        label.textColor = .white
        return label
    }()
    
    private var expenseImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(systemName: "square.and.arrow.up")
        image.tintColor = .white
        return image
    }()
    
    private var expenseLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "Futura", size: 22)
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
    
    private var transactionsLabel: UILabel = {
        var label = UILabel()
        label.text = "Transactions"
        label.font = UIFont(name: "Futura-Bold", size: 18)
        label.textColor = .black
        return label
    }()
    
    private lazy var seeAllButton: UILabel = {
        var btn = UILabel()
        btn.text = "See All"
        btn.font = UIFont(name: "Futura", size: 17)
        btn.textColor = .black
        btn.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showAllTransactions))
        btn.addGestureRecognizer(tapGesture)
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
        
        self.incomeLabel.text = "$ \(presenter.calculateAmount(data: self.transactionDataArray, trasnsactionType: .income))"
        self.expenseLabel.text = "$ \(presenter.calculateAmount(data: self.transactionDataArray, trasnsactionType: .expense))"
        self.totalBalance.text = "$ \(presenter.calculateAmount(data: self.transactionDataArray, trasnsactionType: nil))"
    }
    
    @objc private func showAllTransactions() {
        if transactionDataArray!.isEmpty {
            AlertManager.absenceTransactionData(on: self)
        } else {
            self.navigationController?.pushViewController(createFullTransactionViewController(), animated: true)
        }
    }
    
    private func createFullTransactionViewController() -> UIViewController {
        let presenter = FullTransactionPresenter()
        let view = FullTransactionViewController(transactionData: self.transactionDataArray!, presenter: presenter)
        presenter.view = view
        return view
    }
    
    private func setupCardValues() {
        self.incomeLabel.text = "$ \(presenter.calculateAmount(data: self.transactionDataArray, trasnsactionType: .income))"
        self.expenseLabel.text = "$ \(presenter.calculateAmount(data: self.transactionDataArray, trasnsactionType: .expense))"
        self.totalBalance.text = "$ \(presenter.calculateAmount(data: self.transactionDataArray, trasnsactionType: nil))"
    }
    
    deinit {
        print("HomeViewController was deinited")
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.35)
        }
        
        headerView.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(25)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        
        headerView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(2)
            make.left.equalTo(welcomeLabel.snp.left)
        }
        
        headerView.addSubview(card)
        card.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(userNameLabel.snp.bottom).offset(20)
            make.height.equalTo(view.snp.height).multipliedBy(0.25)
        }
        
        card.addSubview(total)
        total.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().inset(15)
        }
        
        card.addSubview(totalBalance)
        totalBalance.snp.makeConstraints { make in
            make.top.equalTo(total.snp.bottom).offset(5)
            make.left.equalTo(total.snp.left)
        }
        
        card.addSubview(incomeView)
        incomeView.snp.makeConstraints { make in
            make.left.equalTo(totalBalance.snp.left)
            make.bottom.equalToSuperview().offset(-15)
            make.height.equalTo(60)
            make.width.equalTo(card.snp.width).multipliedBy(0.4)
        }
        
        incomeView.addSubview(incomeImage)
        incomeImage.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(5)
            make.top.equalToSuperview().inset(5)
            make.width.height.equalTo(20)
        }
        
        incomeView.addSubview(income)
        income.snp.makeConstraints { make in
            make.left.equalTo(incomeImage.snp.right).offset(5)
            make.top.equalToSuperview().inset(5)
        }
        
        incomeView.addSubview(incomeLabel)
        incomeLabel.snp.makeConstraints { make in
            make.left.equalTo(incomeImage.snp.left).offset(2)
            make.top.equalTo(incomeImage.snp.bottom).offset(5)
        }
        
        card.addSubview(expenseView)
        expenseView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
            make.height.equalTo(60)
            make.width.equalTo(card.snp.width).multipliedBy(0.4)
        }
        
        expenseView.addSubview(expenseImage)
        expenseImage.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(5)
            make.top.equalToSuperview().inset(5)
            make.width.height.equalTo(20)
        }
        
        expenseView.addSubview(expense)
        expense.snp.makeConstraints { make in
            make.left.equalTo(expenseImage.snp.right).offset(5)
            make.top.equalToSuperview().inset(5)
        }
        
        expenseView.addSubview(expenseLabel)
        expenseLabel.snp.makeConstraints { make in
            make.left.equalTo(expenseImage.snp.left).offset(2)
            make.top.equalTo(expenseImage.snp.bottom).offset(5)
        }
        
        view.addSubview(transactionsLabel)
        transactionsLabel.snp.makeConstraints { make in
            make.left.equalTo(card.snp.left)
            make.top.equalTo(card.snp.bottom).offset(30)
        }
        
        view.addSubview(seeAllButton)
        seeAllButton.snp.makeConstraints { make in
            make.right.equalTo(card.snp.right)
            make.top.equalTo(transactionsLabel.snp.top)
        }
        
        view.addSubview(transactionsTableView)
        transactionsTableView.snp.makeConstraints { make in
            make.top.equalTo(transactionsLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(280)
        }
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transactionDataArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        cell.configure(transactionData: transactionDataArray![indexPath.row], isHiddenData: false)
        return cell
    }
}

extension HomeViewController: HomePresenterDelegate {
    func setUsername(username: String) {
        self.userNameLabel.text = username
    }
    
    func didReceiveTransactionData(data: [TransactionModel]) {
        self.transactionDataArray = data
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

