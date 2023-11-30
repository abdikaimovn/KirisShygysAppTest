//
//  TransactionViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 02.11.2023.
//

import UIKit
import SnapKit

final class TransactionViewController: UIViewController, UITextViewDelegate {
    var delegate: TransactionViewControllerDelegate?
    var presenter: TransactionPresenter?
    
    private var headView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.shared.IncomeColor
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
        sControl.selectedSegmentTintColor = UIColor.shared.IncomeColor
        return sControl
    }()
    
    private var transNameLabel: UILabel = {
        var label = UILabel()
        label.text = "Name"
        label.textColor = .black
        label.font = UIFont(name: "Futura", size: 18)
        return label
    }()
    
    private var transNameTextField: UITextField = {
        var field = UITextField()
        field.font = UIFont(name: "Futura", size: 18)
        field.backgroundColor = UIColor(hex: "#eeeeef")
        field.layer.cornerRadius = 10
        field.layer.cornerCurve = .continuous
        field.textColor = .black
        field.returnKeyType = .done
        return field
    }()
    
    private var descriptionLabel: UILabel = {
        var label = UILabel()
        label.text = "Description"
        label.textColor = .black
        label.font = UIFont(name: "Futura", size: 18)
        return label
    }()
    
    private var descriptionTextField: UITextView = {
        var description = UITextView()
        description.backgroundColor = UIColor(hex: "#eeeeef")
        description.textColor = .black
        description.layer.cornerRadius = 10
        description.layer.cornerCurve = .continuous
        description.font = UIFont(name: "Futura", size: 18)
        description.returnKeyType = .done
        return description
    }()
    
    private var amountLabel: UILabel = {
        var label = UILabel()
        label.text = "How much ?"
        label.textColor = .white
        label.font = UIFont(name: "Futura-Bold", size: 25)
        return label
    }()
    
    private var amountTextField: UITextField = {
        var field = UITextField()
        field.font = UIFont(name: "Futura-Bold", size: 40)
        field.backgroundColor = .clear
        field.placeholder = "0.0"
        field.textColor = .white
        field.layer.cornerRadius = 16
        field.keyboardType = .numberPad
        field.returnKeyType = .default
        return field
    }()
    
    private var calendarLabel: UILabel = {
        var label = UILabel()
        label.text = "Transaction date"
        label.textColor = .black
        label.font = UIFont(name: "Futura", size: 18)
        return label
    }()
    
    private var saveButton: UIButton = {
        var button = UIButton()
        var label = UILabel()
        label.font = UIFont(name: "Futura-Bold", size: 22)
        label.textColor = .white
        button.titleLabel?.font = label.font
        button.setTitle("Save", for: .normal)
        button.backgroundColor = UIColor.shared.IncomeColor
        button.layer.cornerRadius = 10
        button.layer.cornerCurve = .continuous
        
        // Set shadow properties
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.4
        
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        var calendar = UIDatePicker()
        calendar.locale = .current
        calendar.datePickerMode = .dateAndTime
        calendar.timeZone = .current
        calendar.backgroundColor = .white
        calendar.preferredDatePickerStyle = .automatic
        calendar.tintColor = UIColor.shared.IncomeColor
        return calendar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupSegmentedControl()
        setupDelegate()
        setupSaveButton()
        
        transNameTextField.delegate = self
        descriptionTextField.delegate = self
    }
    
    deinit{
        print("transaction VC was deinited")
    }
    
    //Connection with the presenter using delegation pattern
    private func setupDelegate() {
        presenter = TransactionPresenter(delegate: self)  // Assign to the property
        self.delegate = presenter
    }
    
    private func setupSaveButton() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc private func saveButtonTapped() {
        guard let amount = Int(amountTextField.text!) else {
            AlertManager.emptyAmountField(on: self)
            return
        }
        
        guard let transName = transNameTextField.text, !transName.isEmpty else {
            AlertManager.emptyNameField(on: self)
            return
        }
        
        let transType = segmentedControl.selectedSegmentIndex == 0 ? TransactionType.income : .expense
        
        let date = datePicker.date.formatted()
        
        let transactionModel = TransactionModel(
            amount: amount,
            type: transType,
            name: transName,
            description: descriptionTextField.text ?? "",
            date: date
        )
        
        self.delegate?.didReceiveTransactionData(transactionData: transactionModel)
        NotificationCenter.default.post(name: Notification.Name("UpdateAfterTransaction"), object: nil)
        self.dismiss(animated: true)
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
        segmentedControl.selectedSegmentTintColor = segmentedControl.selectedSegmentIndex == 0 ? UIColor.shared.IncomeColor : UIColor.shared.ExpenseColor
        datePicker.tintColor = segmentedControl.selectedSegmentTintColor
        saveButton.backgroundColor = segmentedControl.selectedSegmentTintColor
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(hex: "#eeeeef")
        
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
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
            make.centerY.equalToSuperview()
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
        
        let transNameLeftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: transNameTextField.bounds.height)))
        transNameTextField.leftView = transNameLeftView
        transNameTextField.leftViewMode = .always
        
        surfaceView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(transNameTextField.snp.bottom).offset(20)
        }
        
        surfaceView.addSubview(descriptionTextField)
        descriptionTextField.snp.makeConstraints { make in
            make.left.equalTo(segmentedControl.snp.left)
            make.right.equalTo(segmentedControl.snp.right)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.height.equalTo(150)
        }
        
        surfaceView.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextField.snp.bottom).offset(20)
            make.right.equalTo(segmentedControl.snp.right)
        }
        
        surfaceView.addSubview(calendarLabel)
        calendarLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.centerY.equalTo(datePicker.snp.centerY)
        }
        
        surfaceView.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(55)
            make.bottom.equalTo(surfaceView.snp.bottom).offset(-20)
        }
    }
}

extension TransactionViewController: TransactionPresenterDelegate {
    
}

extension TransactionViewController: UITextFieldDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            // Dismiss the keyboard when return is tapped
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss the keyboard when return is tapped
        textField.resignFirstResponder()
        return true
    }
}
