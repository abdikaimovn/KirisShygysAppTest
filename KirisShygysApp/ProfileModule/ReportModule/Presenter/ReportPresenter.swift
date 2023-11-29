//
//  ReportPresenter.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 29.11.2023.
//

import Foundation

protocol ReportViewControllerDelegate: AnyObject{
    
}

protocol ReportPresenterDelegate: AnyObject {
    
}

class ReportPresenter {
    weak var delegate: ReportPresenterDelegate?
    
    init(delegate: ReportPresenterDelegate? = nil) {
        self.delegate = delegate
    }
    
    func receivePageData() {
        
    }
}

extension ReportPresenter: ReportViewControllerDelegate {
    
}
