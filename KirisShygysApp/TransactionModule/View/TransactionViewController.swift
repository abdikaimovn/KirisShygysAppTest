//
//  TransactionViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 02.11.2023.
//

import UIKit
import SnapKit

final class TransactionViewController: UIViewController {
    private let presenter: TransactionPresenter
    
    private let headView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.shared.IncomeColor
        return view
    }()
    
    private let surfaceView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private let segmentedControl: UISegmentedControl = {
        var sControl = UISegmentedControl()
        sControl.insertSegment(withTitle: NSLocalizedString("incomes_label", comment: ""), at: 0, animated: true)
        sControl.insertSegment(withTitle: NSLocalizedString("expenses_label", comment: ""), at: 1, animated: true)
        sControl.selectedSegmentTintColor = UIColor.shared.IncomeColor
        return sControl
    }()
    
    private let transNameLabel: UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("transactionName_label", comment: "")
        label.textColor = .black
        label.font = UIFont.defaultFont(18)
        return label
    }()
    
    private let transNameTextField: UITextField = {
        var field = UITextField()
        field.font = UIFont.defaultFont(18)
        field.backgroundColor = UIColor.shared.LightGray
        field.layer.cornerRadius = 10
        field.layer.cornerCurve = .continuous
        field.textColor = .black
        field.returnKeyType = .done
        return field
    }()
    
    private let descriptionLabel: UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("descriptionLabel", comment: "")
        label.textColor = .black
        label.font = UIFont.defaultFont(18)
        return label
    }()
    
    private let descriptionTextField: UITextView = {
        var description = UITextView()
        description.backgroundColor = UIColor.shared.LightGray
        description.textColor = .black
        description.layer.cornerRadius = 10
        description.layer.cornerCurve = .continuous
        description.font = UIFont.defaultFont(18)
        description.returnKeyType = .done
        return description
    }()
    
    private let amountLabel: UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("amountLabel_title", comment: "")
        label.textColor = .white
        label.font = UIFont.defaultBoldFont(25)
        return label
    }()
    
    private let amountTextField: UITextField = {
        var field = UITextField()
        field.font = UIFont.defaultBoldFont(40)
        field.backgroundColor = .clear
        field.placeholder = "0"
        field.textColor = .white
        field.layer.cornerRadius = 16
        field.keyboardType = .numberPad
        field.returnKeyType = .default
        return field
    }()
    
    private let calendarLabel: UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("date_label", comment: "")
        label.textColor = .black
        label.font = UIFont.defaultFont(18)
        return label
    }()
    
    private let saveButton: UIButton = {
        var button = UIButton()
        var label = UILabel()
        label.font = UIFont.defaultBoldFont(22)
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
        setupSaveButton()
        
        transNameTextField.delegate = self
        descriptionTextField.delegate = self
    }
    
    init(presenter: TransactionPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("transaction VC was deinited")
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
        
        presenter.didReceiveTransactionData(transactionData: transactionModel)
        NotificationCenter.default.post(name: Notification.Name("UpdateAfterTransaction"), object: nil)
        self.dismiss(animated: true)
    }
    
    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlChosen), for: .valueChanged)
    }
    
    @objc func segmentedControlChosen() {
        presenter.segmentedControlChosen(index: segmentedControl.selectedSegmentIndex)
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.shared.LightGray
        
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        headView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
        }
        
        headView.addSubview(amountTextField)
        amountTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
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
            make.edges.equalToSuperview()
        }
        amountTextField.leftView = leftView
        amountTextField.leftViewMode = .always
        
        headView.addSubview(surfaceView)
        surfaceView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(amountTextField.snp.bottom).offset(20)
        }
        
        surfaceView.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        surfaceView.addSubview(transNameLabel)
        transNameLabel.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(15)
        }
        
        surfaceView.addSubview(transNameTextField)
        transNameTextField.snp.makeConstraints { make in
            make.top.equalTo(transNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(segmentedControl.snp.leading)
            make.trailing.equalTo(segmentedControl.snp.trailing)
            make.height.equalTo(40)
        }
        
        let transNameLeftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: transNameTextField.bounds.height)))
        transNameTextField.leftView = transNameLeftView
        transNameTextField.leftViewMode = .always
        
        surfaceView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalTo(transNameTextField.snp.bottom).offset(15)
        }
        
        surfaceView.addSubview(descriptionTextField)
        descriptionTextField.snp.makeConstraints { make in
            make.leading.equalTo(segmentedControl.snp.leading)
            make.trailing.equalTo(segmentedControl.snp.trailing)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.height.equalTo(150)
        }
        
        surfaceView.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextField.snp.bottom).offset(15)
            make.trailing.equalTo(segmentedControl.snp.trailing)
        }
        
        surfaceView.addSubview(calendarLabel)
        calendarLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.centerY.equalTo(datePicker.snp.centerY)
        }
        
        surfaceView.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(50)
            make.bottom.equalTo(surfaceView.snp.bottom).offset(-20)
        }
    }
}

extension TransactionViewController: TransactionViewProtocol {
    func showError(with error: ErrorModel) {
        AlertManager.transactionError(on: self, message: error.text)
    }
    
    func updateViewColors(with color: UIColor) {
        headView.backgroundColor = color
        segmentedControl.selectedSegmentTintColor = color
        datePicker.tintColor = color
        saveButton.backgroundColor = color
    }
}

extension TransactionViewController: UITextFieldDelegate, UITextViewDelegate {
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
