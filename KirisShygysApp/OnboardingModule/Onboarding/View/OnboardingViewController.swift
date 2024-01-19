//
//  OnboardingViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 05.10.2023.
//

import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {
    private let onboardingData: [OnboardingModel] = [
        OnboardingModel(title: "onboarding_firstPage_title".localized,
                        description: "onboarding_firstPage_description".localized,
                        image: UIImage(named: "onbng1")!),
        OnboardingModel(title: "onboarding_secondPage_title".localized,
                        description:"onboarding_secondPage_description".localized,
                        image: UIImage(named: "onbng2")!)
    ]
    
    private lazy var sliderCollView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.height * 0.6)
        var cView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cView.dataSource = self
        cView.delegate = self
        cView.backgroundColor = .white
        cView.isPagingEnabled = true
        cView.showsHorizontalScrollIndicator = false
        cView.register(OnboardingCVCell.self, forCellWithReuseIdentifier: "OnboardingCVCell")
        return cView
    }()
    
    private let pageControl: UIPageControl = {
        var pageControl = UIPageControl()
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor.shared.Brown
        pageControl.pageIndicatorTintColor = UIColor.gray
        return pageControl
    }()
    
    private lazy var signUpButton: UIButton = {
        var button = UIButton()
        button.setTitle("signUp_button_title".localized, for: .normal)
        button.backgroundColor = UIColor.shared.Brown
        button.titleLabel?.font = UIFont.defaultBoldFont(20)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        return button
    }()
    
    private lazy var signInButton: UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.setTitle("signIn_button_title".localized, for: .normal)
        button.backgroundColor = UIColor.shared.Brown
        button.titleLabel?.font = UIFont.defaultBoldFont(20)
        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupView()
    }
    
    @objc func signIn() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtonItem
        
        let authorizationService = AuthService.shared
        let authPresenter = AuthorizationPresenter(authorizationService: authorizationService)
        let authView = AuthorizationViewController(presenter: authPresenter)
        authPresenter.view = authView
        
        self.navigationController?.pushViewController(authView, animated: true)
    }
    
    @objc func signUp() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtonItem
        
        let registrationService = AuthService.shared
        let registrationPresenter = RegistrationPresenter(service: registrationService)
        let registrationView = RegistrationViewController(presenter: registrationPresenter)
        registrationPresenter.view = registrationView
        
        self.navigationController?.pushViewController(registrationView, animated: true)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(sliderCollView)
        sliderCollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(view.bounds.height * 0.6)
        }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(sliderCollView.snp.bottom).offset(20)
        }
        
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(55)
        }
        
        view.addSubview(signInButton)
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(55)
        }
    }
}

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
