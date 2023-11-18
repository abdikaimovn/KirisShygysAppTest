//
//  FilterViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 16.11.2023.
//

import UIKit

class FilterViewController: UIViewController {
    private var closeLine: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.shared.Brown
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    deinit {
        print("Filter vc deinited")
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(closeLine)
        closeLine.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            make.height.equalTo(3)
            make.width.equalTo(30)
        }
        
        let filterTransactionLabel = generateTitleLabel("Filter Transaction")
        //Filter titles
        let filterByLabel = generateTitleLabel("Filter By")
        let sortByLabel = generateTitleLabel("Sort By")
        let periodLabel = generateTitleLabel("Period")
        
        //Filter horizontal stack those will contains buttons to identify
        let filterByStack = generateStackView()
        let sortByStack = generateStackView()
        let periodStack = generateStackView()
        
        //Reset button
        let resetButton = generateButton("Reset")
        resetButton.backgroundColor = UIColor.shared.Brown
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

        let filterByExpenseButton = generateButton("Expense")
        let filterByIncomeButton = generateButton("Income")
        
        let sortByHighestButton = generateButton("Highest")
        let sortByLowestButton = generateButton("Lowest")
        let sortByNewestButton = generateButton("Newest")
        let sortByOldestButton = generateButton("Oldest")
        
        let weekPeriodButton = generateButton("Week")
        let monthPeriodButton = generateButton("Month")
        let halfyearPeriodButton = generateButton("6 Months")
        let yearPeriodButton = generateButton("Year")
        
        let applyButton = generateButton("Apply")
        applyButton.backgroundColor = UIColor.shared.Brown
        applyButton.setTitleColor(.white, for: .normal)
        
        view.addSubview(filterTransactionLabel)
        filterTransactionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(closeLine.snp.top).inset(20)
        }
        
        view.addSubview(resetButton)
        resetButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalTo(filterTransactionLabel.snp.centerY)
        }
        
        view.addSubview(filterByLabel)
        filterByLabel.snp.makeConstraints { make in
            make.top.equalTo(filterTransactionLabel.snp.bottom).offset(30)
            make.left.equalTo(filterTransactionLabel.snp.left)
        }
        
        view.addSubview(filterByStack)
        filterByStack.snp.makeConstraints { make in
            make.top.equalTo(filterByLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
    
        filterByStack.addArrangedSubview(filterByExpenseButton)
        filterByStack.addArrangedSubview(filterByIncomeButton)
        
        view.addSubview(sortByLabel)
        sortByLabel.snp.makeConstraints { make in
            make.top.equalTo(filterByStack.snp.bottom).offset(30)
            make.left.equalTo(filterTransactionLabel.snp.left)
        }
        
        view.addSubview(sortByStack)
        sortByStack.snp.makeConstraints { make in
            make.top.equalTo(sortByLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
    
        sortByStack.addArrangedSubview(sortByHighestButton)
        sortByStack.addArrangedSubview(sortByLowestButton)
        sortByStack.addArrangedSubview(sortByNewestButton)
        sortByStack.addArrangedSubview(sortByOldestButton)
        
        view.addSubview(periodLabel)
        periodLabel.snp.makeConstraints { make in
            make.top.equalTo(sortByStack.snp.bottom).offset(30)
            make.left.equalTo(filterTransactionLabel.snp.left)
        }
        
        view.addSubview(periodStack)
        periodStack.snp.makeConstraints { make in
            make.top.equalTo(periodLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        periodStack.addArrangedSubview(weekPeriodButton)
        periodStack.addArrangedSubview(monthPeriodButton)
        periodStack.addArrangedSubview(halfyearPeriodButton)
        periodStack.addArrangedSubview(yearPeriodButton)
        
        view.addSubview(applyButton)
        applyButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(periodStack.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
    
    private func generateButton(_ title: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerCurve = .continuous
        button.layer.borderColor = UIColor.shared.Brown.cgColor
        button.layer.borderWidth = 1
        button.contentHorizontalAlignment = .center
        return button
    }
    
    private func generateTitleLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "Futura", size: 18)
        label.textColor = .black
        return label
    }
    
    private func generateStackView() -> UIStackView {
        let stack = UIStackView()
        stack.backgroundColor = .clear
        stack.spacing = 10
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        return stack
    }

}
