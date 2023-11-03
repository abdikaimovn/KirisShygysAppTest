//
//  TransactionViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 02.11.2023.
//

import UIKit
import SnapKit

@available(iOS 16.0, *)
class TransactionViewController: UIViewController {
    private var headView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.shared.IncomeColor
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    private var surfaceView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private var segmentedControl: UISegmentedControl = {
        var sControl = UISegmentedControl()
        sControl.insertSegment(withTitle: "Income", at: 0, animated: true)
        sControl.insertSegment(withTitle: "Expenses", at: 1, animated: true)
        return sControl
    }()
    
    private var transNameLabel: UILabel = {
        var label = UILabel()
        label.text = "Name"
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        return label
    }()
    
    private var transNameTextField: UITextField = {
        var field = UITextField()
        field.font = UIFont(name: "HelveticaNeue-Bold", size: 23)
        field.backgroundColor = UIColor(hex: "#eeeeef")
        field.layer.cornerRadius = 10
        field.layer.cornerCurve = .continuous
        return field
    }()
    
    private var amountLabel: UILabel = {
        var label = UILabel()
        label.text = "How much ?"
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        return label
    }()
    
    private var amountTextField: UITextField = {
        var field = UITextField()
        field.font = UIFont(name: "HelveticaNeue-Bold", size: 40)
        field.backgroundColor = .clear
        field.placeholder = "0.0"
        field.textColor = .white
        field.layer.cornerRadius = 16
        field.keyboardType = .numberPad
        return field
    }()
    
    private lazy var calendar: UICalendarView = {
        var calendar = UICalendarView()
        calendar.delegate = self
        calendar.locale = .current
        calendar.fontDesign = .rounded
        calendar.timeZone = .current
        calendar.backgroundColor = .white
        calendar.tintColor = UIColor.shared.Brown
        return calendar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSegmentedControl()
    }
    
    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlChosen), for: .valueChanged)
    }
    
    @objc func segmentedControlChosen() {
        if segmentedControl.selectedSegmentIndex == 0 {
            headView.backgroundColor = UIColor.shared.IncomeColor
        } else {
            headView.backgroundColor = UIColor.shared.ExpenseColor
        }
    }

    
    private func setupView() {
        view.backgroundColor = UIColor(hex: "#eeeeef")
        
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.5)
        }
        
        headView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(30)
        }
        
        headView.addSubview(amountTextField)
        amountTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(amountLabel.snp.bottom).offset(15)
        }
        //Left view mode of the amount text field
        let leftView = UIView()
        leftView.backgroundColor = .clear
        let dollarLabel = UILabel()
        dollarLabel.text = "$ "
        dollarLabel.font = amountTextField.font
        dollarLabel.textColor = .white
        leftView.addSubview(dollarLabel)
        dollarLabel.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        amountTextField.leftView = leftView
        amountTextField.leftViewMode = .always

        headView.addSubview(surfaceView)
        surfaceView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(amountTextField.snp.bottom).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        surfaceView.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.left.right.equalToSuperview().inset(10)
        }
        
        surfaceView.addSubview(transNameLabel)
        transNameLabel.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(15)
        }
        
        surfaceView.addSubview(transNameTextField)
        transNameTextField.snp.makeConstraints { make in
            make.top.equalTo(transNameLabel.snp.bottom).offset(10)
            make.left.equalTo(segmentedControl.snp.left)
            make.right.equalTo(segmentedControl.snp.right)
            make.height.equalTo(40)
        }
        
        
    }

}

@available(iOS 16.0, *)
extension TransactionViewController: UICalendarViewDelegate {
    
}
