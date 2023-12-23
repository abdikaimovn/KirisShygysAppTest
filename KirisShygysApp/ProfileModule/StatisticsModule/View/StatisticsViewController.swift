//
//  StatisticsViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 21.12.2023.
//

import UIKit
import DGCharts
import SnapKit

final class StatisticsViewController: UIViewController {
    private let presenter: StatisticsPresenter
    
    private let transactionType: UISegmentedControl = {
        var sControl = UISegmentedControl()
        sControl.insertSegment(withTitle: "Incomes", at: 0, animated: true)
        sControl.insertSegment(withTitle: "Expenses", at: 1, animated: true)
        sControl.selectedSegmentTintColor = UIColor.shared.IncomeColor
        sControl.selectedSegmentIndex = 0
        return sControl
    }()
    
    private lazy var chart: BarChartView = {
        var chart = BarChartView()
        chart.backgroundColor = .clear
        chart.delegate = self
        return chart
    }()
    
    private let chosenPeriod: UISegmentedControl = {
        var sControl = UISegmentedControl()
        sControl.insertSegment(withTitle: "Week", at: 0, animated: true)
        sControl.insertSegment(withTitle: "Month", at: 1, animated: true)
        sControl.insertSegment(withTitle: "Year", at: 2, animated: true)
        sControl.selectedSegmentTintColor = UIColor.shared.Brown
        sControl.selectedSegmentIndex = 0
        return sControl
    }()
    
    init(presenter: StatisticsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem

        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        }

        self.title = "Statistics"

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(transactionType)
        transactionType.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
        }
        
        view.addSubview(chart)
        chart.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(transactionType).offset(20)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        
        view.addSubview(chosenPeriod)
        chosenPeriod.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(chart.snp.bottom).offset(20)
        }
    }
}

extension StatisticsViewController: StatisticsViewProtocol {
    
}

extension StatisticsViewController: ChartViewDelegate {
    
}
