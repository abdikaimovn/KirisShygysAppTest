//
//  HomePresenterTest.swift
//  KirisShygysAppTests
//
//  Created by Нурдаулет on 25.12.2023.
//

import XCTest
@testable import KirisShygysApp

final class HomeModuleTest: XCTestCase {
    private var homePresenter: HomePresenter!
    private var mockHomeView: MockHomeView!
    private var userManager: UserInfoProtocol!
    
    override func setUpWithError() throws {
        userManager = MockUserDataManager()
        homePresenter = HomePresenter(userManager: userManager)
        mockHomeView = MockHomeView()
        homePresenter.view = mockHomeView
    }

    override func tearDownWithError() throws {
        userManager = nil
        homePresenter = nil
        mockHomeView = nil
        super.tearDown()
    }
    
    func testViewDidLoadedSuccess() throws {
        homePresenter.viewDidLoaded()
        
        XCTAssertTrue(mockHomeView.showLoaderCalled)
        XCTAssertTrue(mockHomeView.setUsernameCalled)
        XCTAssertTrue(mockHomeView.updateTransactionsDataCalled)
        XCTAssertTrue(mockHomeView.hideLoaderCalled)
    }
}

final class MockUserDataManager: UserInfoProtocol{
    func fetchCurrentUsername(completion: @escaping (Result<String, Error>) -> Void) {
        completion(.success("TestName"))
    }
    
    func fetchTransactionData(completion: @escaping (Result<[KirisShygysApp.TransactionModel], KirisShygysApp.FetchingTransactionsError>) -> Void) {
        completion(.success([KirisShygysApp.TransactionModel]()))
    }
}

final class MockHomeView: HomeViewProtocol {
    var setUsernameCalled = false
    var updateTransactionsDataCalled = false
    var showLoaderCalled = false
    var hideLoaderCalled = false
    var pushAllTransactionsViewCalled = false
    var showAbsenseDataAlertCalled = false
    var updateCardViewValuesCalled = false
    var showUnknownErrorCalled = false
    var showUpdatingErrorCalled = false
    
    func setUsername(username: String) {
        setUsernameCalled = true
    }
    
    func updateTransactionsData(with: [KirisShygysApp.TransactionModel]) {
        updateTransactionsDataCalled = true
    }
    
    func showLoader() {
        showLoaderCalled = true
    }
    
    func hideLoader() {
        hideLoaderCalled = true
    }
    
    func pushAllTransactionsView() {
        pushAllTransactionsViewCalled = true
    }
    
    func showAbsenseDataAlert() {
        showAbsenseDataAlertCalled = true
    }
    
    func updateCardViewValues(cardViewModel: KirisShygysApp.CardViewModel) {
        updateCardViewValuesCalled = true
    }
    
    func showUnknownError(with model: KirisShygysApp.ErrorModel) {
        showUnknownErrorCalled = true
    }
    
    func showUpdatingError(with error: Error) {
        showUpdatingErrorCalled = true
    }
}
