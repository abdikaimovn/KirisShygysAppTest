//
//  ViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 05.10.2023.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    private var welcomeLabel: UILabel = {
        var label = UILabel()
        label.text = "Welcome Back,"
        label.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        label.textColor = .black
        return label
    }()
    
    private var userNameLabel: UILabel = {
        var label = UILabel()
        label.text = "Nurdaulet"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        label.textColor = .black
        return label
    }()
    
    private var card: UIView = {
        var card = UIView()
        card.backgroundColor = UIColor.shared.Brown
        card.layer.cornerRadius = 10
        card.clipsToBounds = true
        return card
    }()
    
    private var total: UILabel = {
        var label = UILabel()
        label.text = "Total Balance:"
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.textColor = .white
        return label
    }()
    
    private var totalBalance: UILabel = {
        var label = UILabel()
        label.text = "$ 15,000"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 35)
        label.textColor = .white
        return label
    }()
    
    private var chipImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "chip")
        return image
    }()
    
    //Income view
    private var incomeView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private var income: UILabel = {
        var label = UILabel()
        label.text = "Income"
        label.textColor = UIColor(hex: "#1AFB1A")
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        return label
    }()
    
    private var incomeImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(systemName: "square.and.arrow.down")
        image.tintColor = UIColor(hex: "#1AFB1A")
        return image
    }()
    
    private var incomeLabel: UILabel = {
        var label = UILabel()
        label.text = "$ 12,239"
        label.font = UIFont(name: "HelveticaNeue", size: 22)
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
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        label.textColor = UIColor(hex: "#EF0A0A")
        return label
    }()
    
    private var expenseImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(systemName: "square.and.arrow.up")
        image.tintColor = UIColor(hex: "#EF0A0A")
        return image
    }()
    
    private var expenseLabel: UILabel = {
        var label = UILabel()
        label.text = "$ 2423"
        label.font = UIFont(name: "HelveticaNeue", size: 22)
        label.textColor = .white
        return label
    }()
    
    private lazy var transactionsTableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "TransactionTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        UIFont.familyNames.forEach({ familyName in
//                   let fontNames = UIFont.fontNames(forFamilyName: familyName)
//                   print(familyName, fontNames)
//               })
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(25)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-60)
        }
        
        view.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(2)
            make.left.equalTo(welcomeLabel.snp.left)
        }
        
        view.addSubview(card)
        card.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(userNameLabel.snp.bottom).offset(20)
            make.height.equalTo(view.snp.height).multipliedBy(0.25)
        }
        
        card.addSubview(chipImage)
        chipImage.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
            make.width.equalToSuperview().multipliedBy(0.14)
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
            make.width.equalTo(140)
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
            make.width.equalTo(140)
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
        
        view.addSubview(transactionsTableView)
        transactionsTableView.snp.makeConstraints { make in
            make.top.equalTo(card.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
        //        //D0E5E4
        //        let logOutBtn = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(logOut))
        //        logOutBtn.title = "Log Out"
        //        self.navigationItem.rightBarButtonItem = logOutBtn
    }
    
    //    @objc private func logOut() {
    //        AuthService.shared.signOut { [weak self] error in
    //            guard let self = self else {return}
    //
    //            if let error = error {
    //                AlertManager.showLogOutErrorAlert(on: self, with: error)
    //                return
    //            }
    //
    //            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
    //                sceneDelegate.checkAuthentication()
    //            }
    //        }
    //    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        return cell
    }
}
