import UIKit

final class FullTransactionViewController: UIViewController {
    private let transactionData: [TransactionModel]!
    private var groupedTransactions: [String: [TransactionModel]] = [:]
    private var changedTransactionData: [TransactionModel]?
    private var sectionTitles: [SectionTitleModel] = []
    private let presenter: FullTransactionPresenterProtocol
    
    private let loader = UIActivityIndicatorView()
    private let loaderView = UIView()
    
    private var filterTransactionLabel: UILabel = {
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
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(filterGestureRecognizer))
        image.addGestureRecognizer(tapGestureRecognizer)
        return image
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "TransactionTableViewCell")
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    init(transactionData: [TransactionModel], presenter: FullTransactionPresenterProtocol) {
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
            make.left.equalToSuperview().inset(20)
        }
        
        view.addSubview(filterImage)
        filterImage.snp.makeConstraints { make in
            make.centerY.equalTo(filterTransactionLabel.snp.centerY)
            make.right.equalToSuperview().inset(20)
            make.size.equalTo(30)
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.top.equalTo(filterImage.snp.bottom).offset(10)
        }
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
        
        switch sectionTitle {
        case Date.now.formatted().prefix(10):
            return "Today"
        case Date().yesterday.formatted().prefix(10):
            return "Yesterday"
        default:
            return sectionTitle
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        
        let sectionTitle = sectionTitles[indexPath.section].sectionTitleDate
        if let transactions = groupedTransactions[sectionTitle] {
            let transaction = transactions[indexPath.row]
            cell.configure(transactionData: transaction, isHiddenData: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailTransactionVC = DetailTransactionViewController()
        
        if let transactions = groupedTransactions[sectionTitles[indexPath.section].sectionTitleDate] {
            let transaction = transactions[indexPath.row]
            detailTransactionVC.configure(transactionInfo: transaction)
        }
        
        if let sheet = detailTransactionVC.sheetPresentationController {
            sheet.detents = [.medium(),.large()]
        }
        
        self.present(detailTransactionVC, animated: true, completion: nil)
    }
}

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
