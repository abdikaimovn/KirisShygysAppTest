import UIKit
import SnapKit

final class TransactionTableViewCell: UITableViewCell {
    private let mainView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 6
        view.layer.cornerCurve = .continuous
        view.backgroundColor = UIColor.shared.LightGray
        return view
    }()
    
    private let viewImage: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 6
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private let image: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: "square.and.arrow.up")
        image.tintColor = .white
        image.backgroundColor = .clear
        return image
    }()
    
    private let transName: UILabel = {
        var label = UILabel()
        label.font = UIFont.defaultFont(16)
        label.textColor = .black
        label.isHidden = false
        label.numberOfLines = 1
        return label
    }()
    
    private let purchasedData: UILabel = {
        var label = UILabel()
        label.font = UIFont.defaultFont(14)
        label.textColor = .black
        return label
    }()
    
    private let priceLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.defaultBoldFont(16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(transactionData: TransactionModel) {
        let currentData = Date.now.formatted().prefix(10)
        self.transName.text = transactionData.transactionName
        self.priceLabel.text = "\("currency".localized) \(transactionData.transactionAmount)"
        self.priceLabel.textColor = transactionData.transactionType == .income ? UIColor.shared.IncomeColor : UIColor.shared.ExpenseColor
        self.purchasedData.text = transactionData.transactionDate.prefix(10) == currentData ? "today_label".localized : String(transactionData.transactionDate.prefix(10))
        viewImage.backgroundColor = priceLabel.textColor
        image.image = transactionData.transactionType == .income ? UIImage(systemName: "square.and.arrow.down") : UIImage(systemName: "square.and.arrow.up")
    }
    
    private func setupView() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview()
        }
        
        mainView.addSubview(viewImage)
        viewImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(10)
            make.size.equalTo(50)
        }
        
        viewImage.addSubview(image)
        image.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview().inset(10)
        }
        
        mainView.addSubview(transName)
        transName.snp.makeConstraints { make in
            make.leading.equalTo(viewImage.snp.trailing).offset(15)
            make.top.equalTo(viewImage.snp.top)
        }
    
        mainView.addSubview(purchasedData)
        purchasedData.snp.makeConstraints { make in
            make.leading.equalTo(viewImage.snp.trailing).offset(15)
            make.bottom.equalTo(viewImage.snp.bottom)
        }
        
        mainView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(transName.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
        priceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}
