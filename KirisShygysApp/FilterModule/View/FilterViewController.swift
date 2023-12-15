//
//  FilterViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 16.11.2023.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func didGetFilterSettings(filterData: FilterModel)
}

class FilterViewController: UIViewController {
    weak var delegate: FilterViewControllerDelegate?
    private var filterModel: FilterModel? = FilterModel(filterBy: nil, sortBy: nil, period: nil)
    
    init(delegate: FilterViewControllerDelegate?) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var filterByExpenseButton: UIButton = {
        var button = generateButton("Expense")
        return button
    }()
    
    private lazy var filterByIncomeButton: UIButton = {
        var button = generateButton("Income")
        return button
    }()
    
    private lazy var sortByNewestButton: UIButton = {
        var button = generateButton("Newest")
        return button
    }()
    
    private lazy var sortByOldestButton: UIButton = {
        var button = generateButton("Oldest")
        return button
    }()
    
    private lazy var weekPeriodButton: UIButton = {
        var button = generateButton("Week")
        return button
    }()
    
    private lazy var monthPeriodButton: UIButton = {
        var button = generateButton("Month")
        return button
    }()
    
    private lazy var halfyearPeriodButton: UIButton = {
        var button = generateButton("6 Months")
        return button
    }()
    
    private lazy var yearPeriodButton: UIButton = {
        var button = generateButton("Year")
        return button
    }()
    
    private lazy var resetButton: UIButton = {
        var button = UIButton()
        button.setTitle("Reset", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.defaultFont(18)
        button.layer.cornerCurve = .continuous
        button.backgroundColor = UIColor.shared.ExpenseColor
        button.setTitleColor(.white, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        return button
    }()
    
    private lazy var applyButton: UIButton = {
        var button = generateButton("Apply")
        button.backgroundColor = UIColor.shared.Brown
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.defaultBoldFont(18)
        return button
    }()
    
    private var closeLine: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.shared.Brown
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        activateButtons()
    }
    
    deinit {
        print("Filter vc deinited")
    }
    
    private func activateButtons() {
        self.resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
        self.filterByIncomeButton.addTarget(self, action: #selector(incomeButtonTapped), for: .touchUpInside)
        self.filterByExpenseButton.addTarget(self, action: #selector(expenseButtonTapped), for: .touchUpInside)

        self.sortByNewestButton.addTarget(self, action: #selector(sortByNewestButtonTapped), for: .touchUpInside)
        self.sortByOldestButton.addTarget(self, action: #selector(sortByOldestButtonTapped), for: .touchUpInside)
        
        self.weekPeriodButton.addTarget(self, action: #selector(weekPeriodButtonTapped), for: .touchUpInside)
        self.monthPeriodButton.addTarget(self, action: #selector(monthPeriodButtonTapped), for: .touchUpInside)
        self.halfyearPeriodButton.addTarget(self, action: #selector(halfyearPeriodButtonTapped), for: .touchUpInside)
        self.yearPeriodButton.addTarget(self, action: #selector(yearPeriodButtonTapped), for: .touchUpInside)
        
        self.applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
    }
    
    @objc private func applyButtonTapped() {
        delegate!.didGetFilterSettings(filterData: self.filterModel!)
        self.dismiss(animated: true)
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
        
        //Filter horizontal stack those will contain buttons to identify
        let filterByStack = generateStackView()
        let sortByStack = generateStackView()
        let periodStack = generateStackView()
        
        view.addSubview(filterTransactionLabel)
        filterTransactionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(closeLine.snp.bottom).offset(20)
        }
        
        view.addSubview(resetButton)
        resetButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(filterTransactionLabel.snp.trailing).offset(20)
            make.centerY.equalTo(filterTransactionLabel.snp.centerY)
        }

        view.addSubview(filterByLabel)
        filterByLabel.snp.makeConstraints { make in
            make.top.equalTo(filterTransactionLabel.snp.bottom).offset(30)
            make.leading.equalTo(filterTransactionLabel.snp.leading)
        }
        
        view.addSubview(filterByStack)
        filterByStack.snp.makeConstraints { make in
            make.top.equalTo(filterByLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    
        filterByStack.addArrangedSubview(filterByExpenseButton)
        filterByStack.addArrangedSubview(filterByIncomeButton)
        
        view.addSubview(sortByLabel)
        sortByLabel.snp.makeConstraints { make in
            make.top.equalTo(filterByStack.snp.bottom).offset(30)
            make.leading.equalTo(filterTransactionLabel.snp.leading)
        }
        
        view.addSubview(sortByStack)
        sortByStack.snp.makeConstraints { make in
            make.top.equalTo(sortByLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        sortByStack.addArrangedSubview(sortByNewestButton)
        sortByStack.addArrangedSubview(sortByOldestButton)
        
        view.addSubview(periodLabel)
        periodLabel.snp.makeConstraints { make in
            make.top.equalTo(sortByStack.snp.bottom).offset(30)
            make.leading.equalTo(filterTransactionLabel.snp.leading)
        }
        
        view.addSubview(periodStack)
        periodStack.snp.makeConstraints { make in
            make.top.equalTo(periodLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        periodStack.addArrangedSubview(weekPeriodButton)
        periodStack.addArrangedSubview(monthPeriodButton)
        periodStack.addArrangedSubview(halfyearPeriodButton)
        periodStack.addArrangedSubview(yearPeriodButton)
        
        view.addSubview(applyButton)
        applyButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
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
        label.font = UIFont.defaultFont(18)
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

//MARK: - Functionality of buttons in stackViews
extension FilterViewController {
    private func updateButtons(_ selectedButton: UIButton, _ buttons: [UIButton]) {
        UIView.animate(withDuration: 0.2) {
            selectedButton.backgroundColor = UIColor.shared.Brown
            selectedButton.setTitleColor(.white, for: .normal)

            for button in buttons {
                if button != selectedButton {
                    button.backgroundColor = .clear
                    button.setTitleColor(.black, for: .normal)
                }
            }
        }
    }
    
    @objc private func resetButtonTapped() {
        updateButtons(resetButton, [filterByExpenseButton, filterByIncomeButton,
                                    sortByNewestButton, sortByOldestButton,
                                    monthPeriodButton, halfyearPeriodButton, yearPeriodButton, weekPeriodButton])
        resetButton.backgroundColor = UIColor.shared.ExpenseColor
        resetButton.setTitleColor(.white, for: .normal)
        self.filterModel = FilterModel(filterBy: nil, sortBy: nil, period: nil)
        applyButtonTapped()
    }
    
    @objc private func expenseButtonTapped() {
        updateButtons(filterByExpenseButton, [filterByIncomeButton])
        self.filterModel?.filterBy = .expense
    }
    
    @objc private func incomeButtonTapped() {
        updateButtons(filterByIncomeButton, [filterByExpenseButton])
        self.filterModel?.filterBy = .income
    }
    
    @objc private func sortByNewestButtonTapped() {
        updateButtons(sortByNewestButton, [sortByOldestButton])
        self.filterModel?.sortBy = .newest
    }
    
    @objc private func sortByOldestButtonTapped() {
        updateButtons(sortByOldestButton, [sortByNewestButton])
        self.filterModel?.sortBy = .oldest
    }
    
    @objc private func weekPeriodButtonTapped() {
        updateButtons(weekPeriodButton, [monthPeriodButton, halfyearPeriodButton, yearPeriodButton])
        self.filterModel?.period = .week
    }
    
    @objc private func monthPeriodButtonTapped() {
        updateButtons(monthPeriodButton, [weekPeriodButton, halfyearPeriodButton, yearPeriodButton])
        self.filterModel?.period = .month
    }
    
    @objc private func halfyearPeriodButtonTapped() {
        updateButtons(halfyearPeriodButton, [monthPeriodButton, weekPeriodButton, yearPeriodButton])
        self.filterModel?.period = .halfyear
    }
    
    @objc private func yearPeriodButtonTapped() {
        updateButtons(yearPeriodButton, [monthPeriodButton, halfyearPeriodButton, weekPeriodButton])
        self.filterModel?.period = .year
    }
}
