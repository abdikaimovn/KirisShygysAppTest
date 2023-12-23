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
    private let transactionData: [TransactionModel]
    
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
        chart.backgroundColor = .white
        chart.gridBackgroundColor = .clear
        chart.layer.cornerRadius = 20
        chart.layer.cornerCurve = .continuous
        chart.delegate = self
        chart.isUserInteractionEnabled = false
        return chart
    }()
    
    private let chosenPeriod: UISegmentedControl = {
        var sControl = UISegmentedControl()
        sControl.insertSegment(withTitle: "Week", at: 0, animated: true)
        sControl.insertSegment(withTitle: "Month", at: 1, animated: true)
        sControl.insertSegment(withTitle: "Year", at: 2, animated: true)
        sControl.selectedSegmentTintColor = UIColor.shared.IncomeColor
        sControl.selectedSegmentIndex = 0
        return sControl
    }()
    
    init(transactionData: [TransactionModel], presenter: StatisticsPresenter) {
        self.presenter = presenter
        self.transactionData = transactionData
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
        setChartData()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.shared.LightGray
        
        view.addSubview(transactionType)
        transactionType.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
        }
        
        view.addSubview(chart)
        chart.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(transactionType.snp.bottom).offset(20)
        }
        
        view.addSubview(chosenPeriod)
        chosenPeriod.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(chart.snp.bottom).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
    
    func setChartData() {
        // Dummy data (replace this with your actual data)
        let entries: [BarChartDataEntry] = [
            BarChartDataEntry(x: 1.0, y: 1101.0, data: "Mon"),
            BarChartDataEntry(x: 2.0, y: 1100.0, data: "Mon"),
            BarChartDataEntry(x: 3.0, y: 1100.0, data: "Mon"),
            BarChartDataEntry(x: 4.0, y: 1100.0, data: "Tue"),
            BarChartDataEntry(x: 5.0, y: 1100.0, data: "Mon")
        ]
        
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.setColor(UIColor.shared.IncomeColor)
        let data = BarChartData(dataSet: dataSet)
        
        // Optional: Customize the appearance of the chart
        chart.data = data
        chart.xAxis.labelPosition = .bottom
    }
}

extension StatisticsViewController: StatisticsViewProtocol {
    func showLoader() {
        
    }
    
    func hideLoader() {
        
    }
    
    
}

extension StatisticsViewController: ChartViewDelegate {
    
}
