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
        pageControl.numberOfPages = 2
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
        return collView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwipeGesture()
        setupView()
    }
    
    private func setupSwipeGesture() {
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown))
        swipeDownGesture.direction = .down
        self.view.addGestureRecognizer(swipeDownGesture)
    }
    
    @objc func swipedDown() {
        dismiss(animated: true)
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.shared.ExpenseColor
        
        
        view.addSubview(storiesCollectionView)
        storiesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        storiesCollectionView.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(5)
            make.left.right.equalToSuperview().inset(20)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
    }
    
    private func updatePageControlColor() {
        pageControl.pageIndicatorTintColor = UIColor(hex: "#CCCCCC")
        pageControl.currentPageIndicatorTintColor = .white
    }
}

extension ReportViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        reportData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryCollectionViewCell", for: indexPath) as! StoryCollectionViewCell
        
        cell.configure(reportModel: reportData[indexPath.row])
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        pageControl.currentPage = Int(scrollView.contentOffset.x / width)
        updatePageControlColor()
    }

}
