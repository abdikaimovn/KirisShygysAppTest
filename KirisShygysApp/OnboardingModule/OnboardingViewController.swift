//
//  OnboardingViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 05.10.2023.
//

import UIKit
import SnapKit

class OnboardingViewController: UIViewController {
    private let onboardingData: [OnboardingModel] = [
        OnboardingModel(title: "Gain total control\nof your money",
                        description: "Become your own money manager\nand make every cent count",
                        image: UIImage(named: "onbng1")!),
        OnboardingModel(title: "Know where your\nmoney goes",
                        description: "Track your transaction easily,\nwith categories and financial report ",
                        image: UIImage(named: "onbng2")!)
    ]
    
    private lazy var sliderCollView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.height * 0.6)
        var cView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cView.dataSource = self
        cView.isPagingEnabled = true
        cView.delegate = self
        cView.showsHorizontalScrollIndicator = false
        cView.register(OnboardingCVCell.self, forCellWithReuseIdentifier: "OnboardingCVCell")
        return cView
    }()
    
    private var pageControl: UIPageControl = {
        var pageControl = UIPageControl()
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor(hex: "#B88E4E")
        pageControl.pageIndicatorTintColor = UIColor.gray
        return pageControl
    }()
    
    private var signUpButton: UIButton = {
        var button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor(hex: "#B88E4E")
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        return button
    }()
    
    private var signInButton: UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = UIColor.shared.darkBrown
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        
        setupUI()
    }
    
    @objc func signIn() {
        
    }
    
    @objc func signUp() {
        
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(sliderCollView)
        sliderCollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(view.bounds.height * 0.6)
        }
        
        view.addSubview(pageControl)
        
        pageControl.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(sliderCollView.snp.bottom).offset(20)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
        view.addSubview(signUpButton)
        
        signUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pageControl.snp.bottom).offset(20)
            make.width.equalTo(340)
            make.height.equalTo(55)
        }
        
        view.addSubview(signInButton)
        signInButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(signUpButton.snp.bottom).offset(15)
            make.width.equalTo(340)
            make.height.equalTo(55)
        }
    }
}

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        onboardingData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCVCell", for: indexPath) as! OnboardingCVCell
        cell.configure(onboardingModel: onboardingData[indexPath.row])
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        pageControl.currentPage = Int(scrollView.contentOffset.x / width)
    }
}
