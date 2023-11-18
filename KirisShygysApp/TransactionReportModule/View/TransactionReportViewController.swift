import UIKit

final class TransactionReportViewController: UIViewController {
    var transactionData: [TransactionModel]?
    var groupedTransactions: [String: [TransactionModel]] = [:]
    var sectionTitles: [String] = []
    
    private var periodView: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 5
        view.layer.cornerCurve = .continuous
        view.layer.borderColor = UIColor.shared.Brown.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private var filterImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(systemName: "slider.vertical.3")
        image.tintColor = UIColor.shared.Brown
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private var reportView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(hex: "#f9f7f4")
        view.layer.cornerRadius = 5
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private var reportLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.shared.Brown
        label.text = "See your financial report"
        label.font = UIFont(name: "Futura", size: 17)
        return label
    }()
    
    private var rightArrow: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(systemName: "arrow.right.square")
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor.shared.Brown
        return image
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "TransactionTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupedTransactions = Dictionary(grouping: transactionData ?? [], by: { $0.transactionDate })
        sectionTitles = groupedTransactions.keys.sorted(by: >)

        filterImage.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(filterGestureRecognizer))
        filterImage.addGestureRecognizer(tapGestureRecognizer)

        
        setupView()
    }
    
    @objc func filterGestureRecognizer() {
        let transactionFilterVC = FilterViewController()
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
        
        view.addSubview(filterImage)
        filterImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            make.left.equalToSuperview().inset(20)
            make.size.equalTo(30)
        }
        
        view.addSubview(reportView)
        reportView.snp.makeConstraints { make in
            make.left.equalTo(filterImage.snp.right).offset(20)
            make.right.equalToSuperview().inset(20)
            make.centerY.equalTo(filterImage.snp.centerY)
        }
        
        reportView.addSubview(reportLabel)
        reportLabel.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview().inset(15)
        }
        
        reportView.addSubview(rightArrow)
        rightArrow.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.top.equalTo(reportView.snp.bottom).offset(10)
        }
    }
}

extension TransactionReportViewController: UITableViewDelegate, UITableViewDataSource {
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
