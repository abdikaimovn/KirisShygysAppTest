//
//  ReportViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 29.11.2023.
//

import UIKit

final class ReportViewController: UIViewController {
    private let presenter: ReportPresenter
    private let transactionData: [TransactionModel]!
    
    private var reportData = [
        ReportModel(transactionType: "You Spend 💸", amount: "$ 0", biggestTransactionLabel: "and your biggest spending is from", biggestTransactionName: "None", biggestTransactionAmount: "$ 0"),
        ReportModel(transactionType: "You Earned 💰", amount: "$ 0", biggestTransactionLabel: "your biggest Income is from", biggestTransactionName: "None", biggestTransactionAmount: "$ 0")
    ]
    
    private let pageControl: UIPageControl = {
        var pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .white
        return pageControl
    }()
    
    private lazy var storiesCollectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.height * 0.8)
        var collView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collView.dataSource = self
        collView.delegate = self
        collView.backgroundColor = .clear
        collView.isPagingEnabled = true
        collView.showsHorizontalScrollIndicator = false
        collView.register(StoryCollectionViewCell.self, forCellWithReuseIdentifier: "StoryCollectionViewCell")
        collView.register(QuoteCollectionViewCell.self, forCellWithReuseIdentifier: "QuoteCollectionViewCell")
        return collView
    }()
    
    init(transactionData: [TransactionModel], presenter: ReportPresenter) {
        self.presenter = presenter
        self.transactionData = transactionData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupView()
        
        presenter.calculateData(transactionData: self.transactionData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Customize the back button
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .white
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem

        // Customize the title color
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }

        // Set the title
        self.title = "Report"

        // Show the navigation bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.shared.ExpenseColor
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(storiesCollectionView)
        storiesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func updatePageControlAndViewColor() {
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .white
        
        if pageControl.currentPage == 0 {
            view.backgroundColor = UIColor.shared.ExpenseColor
        } else if pageControl.currentPage == 1 {
            view.backgroundColor = UIColor.shared.IncomeColor
        } else {
            view.backgroundColor = UIColor.shared.Brown
        }
    }
}

extension ReportViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 || indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryCollectionViewCell", for: indexPath) as! StoryCollectionViewCell
            cell.configure(reportModel: reportData[indexPath.row])
            return cell
        } else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuoteCollectionViewCell", for: indexPath) as! QuoteCollectionViewCell
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        let currentPage = Int((scrollView.contentOffset.x + width / 2) / width)
        
        // Check if the current page is different from the previous one
        if pageControl.currentPage != currentPage {
            pageControl.currentPage = currentPage
            updatePageControlAndViewColor()
        }
    }

}

extension ReportViewController: ReportViewProtocol {
    func didCalculateTransactionData(_ incomeInfo: ReportInfo, _ expenseInfo: ReportInfo) {
        reportData[0].amount = "$ \(expenseInfo.summa)"
        reportData[0].biggestTransactionAmount = "$ \(expenseInfo.maxValue)"
        reportData[0].biggestTransactionName = expenseInfo.maxValueTitle
        
        reportData[1].amount = "$ \(incomeInfo.summa)"
        reportData[1].biggestTransactionAmount = "$ \(incomeInfo.maxValue)"
        reportData[1].biggestTransactionName = incomeInfo.maxValueTitle
    }
}
