import UIKit

final class FullTransactionViewController: UIViewController {
    private let transactionData: [TransactionModel]?
    private var groupedTransactions: [String: [TransactionModel]] = [:]
    private var sectionTitles: [String] = []
    var presenter: FullTransactionViewControllerDelegate?
    private var changedTransactionData: [TransactionModel]?
    
    private var filterTransactionLabel: UILabel = {
        var label = UILabel()
        label.text = "Filter Transactions"
        label.font = UIFont(name: "Futura", size: 18)
        label.textColor = .black
        return label
    }()
    
    private var filterImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(systemName: "slider.vertical.3")
        image.tintColor = UIColor.shared.Brown
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFit
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDefaultSections(transactionData: self.transactionData)
        setupView()
        activateFilterButton()

        //Connecting with the presenter
        self.presenter = FullTransactionPresenter(delegate: self)
    }
    
    private func activateFilterButton() {
        filterImage.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(filterGestureRecognizer))
        filterImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupDefaultSections(transactionData: [TransactionModel]?) {
        groupedTransactions = Dictionary(grouping: transactionData ?? [], by: { $0.transactionDate })
        sectionTitles = groupedTransactions.keys.sorted(by: >)
    }
    
    private func resetupSections(changedTransactionData: [TransactionModel]?, _ sortByNewest: Bool?) {
        groupedTransactions = Dictionary(grouping: changedTransactionData ?? [], by: { $0.transactionDate })
        
        //By default it sorts in descending order
        sectionTitles = groupedTransactions.keys.sorted(by: >)
        
        if let safeSortByNewest = sortByNewest {
            if !safeSortByNewest {
                sectionTitles = groupedTransactions.keys.sorted(by: <)
            }
        }
    }
    
    @objc func filterGestureRecognizer() {
        let transactionFilterVC = FilterViewController(delegate: self)
        if let sheet = transactionFilterVC.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        self.present(transactionFilterVC, animated: true, completion: nil)
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
    
    init(transactionData: [TransactionModel]) {
        self.transactionData = transactionData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let sectionTitle = sectionTitles[section]
        return groupedTransactions[sectionTitle]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitle = sectionTitles[section]
        
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
        
        let sectionTitle = sectionTitles[indexPath.section]
        if let transactions = groupedTransactions[sectionTitle] {
            let transaction = transactions[indexPath.row]
            cell.configure(transactionData: transaction, isHiddenPeriod: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension FullTransactionViewController: FilterViewControllerDelegate {
    func didGetFilterSettings(filterData: FilterModel) {
        if filterData.period == nil && filterData.sortBy == nil && filterData.filterBy == nil {
            setupDefaultSections(transactionData: self.transactionData)
            tableView.reloadData()
        } else {
            presenter?.didReceiveFilterSettings(filterData, transactionData: self.transactionData!)
        }
    }
}

extension FullTransactionViewController: FullTransactionPresenterDelegate {
    func didFilterTransactionData(filteredData: [TransactionModel], _ sortByNewest: Bool?) {
        resetupSections(changedTransactionData: filteredData, sortByNewest)
        tableView.reloadData()
    }
}
