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
    private var flowModel = [FlowModel]()
    
    private let transactionType: UISegmentedControl = {
        var sControl = UISegmentedControl()
        sControl.insertSegment(withTitle: "incomes_label".localized, at: 0, animated: true)
        sControl.insertSegment(withTitle: "expenses_label".localized, at: 1, animated: true)
        sControl.selectedSegmentTintColor = UIColor.shared.IncomeColor
        sControl.selectedSegmentIndex = 0
        return sControl
    }()
    
    private lazy var chart: BarChartView = {
        var chart = BarChartView()
        chart.backgroundColor = .white
        chart.layer.cornerRadius = 20
        chart.layer.cornerCurve = .continuous
        chart.isUserInteractionEnabled = false
        chart.legend.enabled = false
        chart.xAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawLabelsEnabled = false
        chart.xAxis.labelPosition = .bottom
        chart.animate(yAxisDuration: 1.0)
        chart.rightAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawLabelsEnabled = false
        return chart
    }()
    
    private let chartsScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = true
        return scroll
    }()
    
    private lazy var absenseDataView: UIView = {
        let absenseDataView = AbsenceDataView()
        return absenseDataView
    }()
    
    private lazy var chartBackView: UIView = {
        let view = createBackgroundView()
        return view
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
        title = "statisticsTitle_label".localized
        
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
        let moneyInfoBackView = createBackgroundView()
        
        stackView.addArrangedSubview(controlsBackView)
        stackView.addArrangedSubview(chartBackView)
        stackView.addArrangedSubview(moneyInfoBackView)
        
        controlsBackView.addSubview(transactionType)
        transactionType.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(10)
        }
        
        chartBackView.addSubview(chartsScrollView)
        chartsScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
            make.height.equalTo(300)
        }
        
        chartsScrollView.addSubview(chart)
        chart.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(chartBackView.snp.width).multipliedBy(2)
            make.height.equalToSuperview()
        }
        
        moneyInfoBackView.addSubview(moneyFlowTableView)
        moneyFlowTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
            make.height.equalTo(105)
        }
        
        transactionType.addTarget(self, action: #selector(segmentedControlDidChanged), for: .valueChanged)
    }
    
    func setChartData() {
        presenter.setChart(with: transactionData, and: transactionType.selectedSegmentIndex)
        presenter.setMoneyFlow(with: transactionData)
    }
    
    @objc func segmentedControlDidChanged() {
        presenter.setChart(with: transactionData, and: transactionType.selectedSegmentIndex)
    }
}

extension StatisticsViewController: StatisticsViewProtocol {
    func showAbsenceDataView(withColor color: UIColor) {
        absenseDataView = AbsenceDataView(withColor: color)
        absenseDataView.layer.cornerRadius = chartBackView.layer.cornerRadius
        transactionType.selectedSegmentTintColor = color
        chartBackView.addSubview(absenseDataView)
        absenseDataView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }
    
    func setupMoneyFlow(with moneyFlowModel: [FlowModel]) {
        self.flowModel = moneyFlowModel
    }
    
    func updateView(with color: UIColor) {
        absenseDataView.removeFromSuperview()
        transactionType.selectedSegmentTintColor = color
    }
    
    func setupChart(with model: ChartModel) {
        chart.data = BarChartData(dataSet: model.chartData)
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: model.xAxisTitles)
        chart.xAxis.labelCount = model.xAxisTitles.count
    }
}

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoneyFlowTableViewCell", for: indexPath) as! MoneyFlowTableViewCell
        cell.configure(with: flowModel[indexPath.row])
        return cell
    }
}
