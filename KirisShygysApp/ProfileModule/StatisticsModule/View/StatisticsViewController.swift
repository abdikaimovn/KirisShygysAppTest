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
    private let flowModel = [
        FlowModel(value: 15000, flowImage: .income),
        FlowModel(value: 2000, flowImage: .expense),
        FlowModel(value: 13000, flowImage: .total)
    ]
    
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
        chart.layer.cornerRadius = 20
        chart.layer.cornerCurve = .continuous
        chart.delegate = self
        chart.isUserInteractionEnabled = false
        chart.drawValueAboveBarEnabled = false
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
    
    private lazy var moneyFlowTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(MoneyFlowTableViewCell.self, forCellReuseIdentifier: "MoneyFlowTableViewCell")
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = false
        return tableView
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
    
    private func createBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.cornerCurve = .continuous
        
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3 // Increased opacity for a more noticeable shadow
        view.layer.shadowRadius = 4 // Increased shadow radius

        return view
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.shared.LightGray
         
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        let controlsBackView = createBackgroundView()
        let chartBackView = createBackgroundView()
        let moneyInfoBackView = createBackgroundView()
        
        stackView.addArrangedSubview(controlsBackView)
        stackView.addArrangedSubview(chartBackView)
        stackView.addArrangedSubview(moneyInfoBackView)
        
        controlsBackView.addSubview(transactionType)
        transactionType.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
        }
        
        controlsBackView.addSubview(chosenPeriod)
        chosenPeriod.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(transactionType.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        
        chartBackView.addSubview(chart)
        chart.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
            make.height.equalTo(300)
        }
        
        moneyInfoBackView.addSubview(moneyFlowTableView)
        moneyFlowTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
            make.height.equalTo(105)
        }
    }
    
    func setChartData() {
        // Dummy data (replace this with your actual data)
        var entries: [BarChartDataEntry] = []
        var xValues = [String]()
        xValues.append("1 week")
        xValues.append("2 weeks")
        xValues.append("3 weeks")
        xValues.append("4 weeks")
        
        for i in 0..<xValues.count {
            entries.append(BarChartDataEntry(x: Double(i), y: Double.random(in: 100...350)))
        }
        
        let dataSet = BarChartDataSet(entries: entries)
        
        dataSet.setColor(UIColor.shared.IncomeColor)
        let data = BarChartData(dataSet: dataSet)
        chart.animate(yAxisDuration: 1.0)
        chart.layer.cornerRadius = 15
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
        chart.xAxis.labelCount = xValues.count
        
        // Optional: Customize the appearance of the chart
        chart.data = data
        chart.legend.enabled = false
        
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

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        flowModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoneyFlowTableViewCell", for: indexPath) as! MoneyFlowTableViewCell
        cell.configure(with: flowModel[indexPath.row])
        return cell
    }
}
