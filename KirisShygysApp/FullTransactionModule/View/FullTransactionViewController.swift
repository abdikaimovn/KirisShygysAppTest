import UIKit

final class FullTransactionViewController: UIViewController {
    private let transactionData: [TransactionModel]!
    private var groupedTransactions: [String: [TransactionModel]] = [:]
    private var changedTransactionData: [TransactionModel]?
    private var sectionTitles: [SectionTitleModel] = []
    private let presenter: FullTransactionPresenter
    
    private let loader = UIActivityIndicatorView()
    private let loaderView = UIView()
    
    private var transactionInfoView: UIView?
    private var closeTransactionInfoButton: UIButton?
    
    private let filterTransactionLabel: UILabel = {
        var label = UILabel()
        label.text = "Filter Transactions"
        label.font = UIFont.defaultBoldFont(18)
        label.textColor = .black
        return label
    }()
    
    private lazy var filterImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(systemName: "slider.vertical.3")
        image.tintColor = UIColor.shared.Brown
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(filterGestureRecognizer)))
        return image
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FullTransactionTableViewCell.self, forCellReuseIdentifier: "FullTransactionTableViewCell")
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    init(transactionData: [TransactionModel], presenter: FullTransactionPresenter) {
        self.transactionData = transactionData
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        presenter.setSectionsByDefault(transactionData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set up custom back button
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = UIColor.shared.Brown
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
        self.title = "Transaction Report"
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func filterGestureRecognizer() {
        let transactionFilterVC = FilterViewController(delegate: self)
        if let sheet = transactionFilterVC.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        self.present(transactionFilterVC, animated: true, completion: nil)
    }
    
    deinit {
        print("Transaction REPORT View Controler deinited")
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(filterTransactionLabel)
        filterTransactionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        view.addSubview(filterImage)
        filterImage.snp.makeConstraints { make in
            make.centerY.equalTo(filterTransactionLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(30)
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.top.equalTo(filterImage.snp.bottom).offset(10)
        }
    }
    
    @objc private func closeButtonTapped() {
        transactionInfoView?.removeFromSuperview()
        navigationItem.hidesBackButton = false
    }
}

extension FullTransactionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = sectionTitles[section].sectionTitleDate
        return groupedTransactions[sectionTitle]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitle = sectionTitles[section].sectionTitleDate
        
        return presenter.identifySectionTitle(sectionTitle)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FullTransactionTableViewCell", for: indexPath) as! FullTransactionTableViewCell
        
        let sectionTitle = sectionTitles[indexPath.section].sectionTitleDate
        if let transactions = groupedTransactions[sectionTitle] {
            let transaction = transactions[indexPath.row]
            cell.configure(transactionData: transaction)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        transactionInfoView = UIView()
        transactionInfoView!.backgroundColor = .gray.withAlphaComponent(0.9)
        transactionInfoView!.frame = view.bounds
        view.addSubview(transactionInfoView!)
        
        closeTransactionInfoButton = UIButton()
        closeTransactionInfoButton!.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeTransactionInfoButton!.tintColor = .white
        
        transactionInfoView!.addSubview(closeTransactionInfoButton!)
        closeTransactionInfoButton!.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(30)
            make.leading.equalToSuperview().inset(20)
        }
        
        closeTransactionInfoButton?.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        let transactionInfo = groupedTransactions[sectionTitles[indexPath.section].sectionTitleDate]![indexPath.row]
        let detailTransactionView = DetailTransactionView(frame: .zero, transactionInfo: transactionInfo)
        
        transactionInfoView!.addSubview(detailTransactionView)
        detailTransactionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(closeTransactionInfoButton!.snp.bottom).offset(20)
            make.height.equalTo(400)
        }
        
        navigationItem.hidesBackButton = true
    }
}

// Connection with FilteViewController to receive filter settings if they exists
extension FullTransactionViewController: FilterViewControllerDelegate {
    func didGetFilterSettings(filterData: FilterModel) {
        if filterData.period == nil && filterData.sortBy == nil && filterData.filterBy == nil {
            presenter.setSectionsByDefault(transactionData)
            tableView.reloadData()
        } else {
            presenter.setFilteredSections(transactionData, filterData)
        }
    }
}

extension FullTransactionViewController: FullTransactionViewProtocol {
    func setupSectionsByDefault(_ groupedTransactions: [String : [TransactionModel]], _ sectionTitles: [SectionTitleModel]) {
        self.groupedTransactions = groupedTransactions
        self.sectionTitles = sectionTitles
        self.tableView.reloadData()
    }
    
    func setupFilteredSections(_ groupedSections: [String : [TransactionModel]], sectionTitles: [SectionTitleModel]) {
        self.groupedTransactions = groupedSections
        self.sectionTitles = sectionTitles
        self.tableView.reloadData()
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
