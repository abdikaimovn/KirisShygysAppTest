//
//  ReportViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 29.11.2023.
//

import UIKit

class ReportViewController: UIViewController{
    private let reportData = [
        ReportModel(transactionType: "You Spend 💸", amount: "$ 2000", biggestTransactionLabel: "and your biggest spending is from", biggestTransactionName: "Salary", biggestTransactionAmount: "$ 1000"),
        ReportModel(transactionType: "You Earned 💰", amount: "$ 200", biggestTransactionLabel: "your biggest Income is from", biggestTransactionName: "Shopping", biggestTransactionAmount: "$ 120")
    ]
    
    private var pageControl: UIPageControl = {
        var pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor(hex: "#CCCCCC")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
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
            make.left.right.equalToSuperview().inset(20)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
        view.addSubview(storiesCollectionView)
        storiesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func updatePageControlColor() {
        pageControl.pageIndicatorTintColor = UIColor(hex: "#CCCCCC")
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
        if indexPath.row == 0 || indexPath.row == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryCollectionViewCell", for: indexPath) as! StoryCollectionViewCell
            cell.configure(reportModel: reportData[indexPath.row])
            return cell
        } else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuoteCollectionViewCell", for: indexPath) as! QuoteCollectionViewCell
            return cell
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        pageControl.currentPage = Int(scrollView.contentOffset.x / width)
        updatePageControlColor()
    }

}
