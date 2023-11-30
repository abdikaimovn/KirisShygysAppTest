import UIKit
import SnapKit

final class TransactionTableViewCell: UITableViewCell {
    private var mainView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 6
        view.layer.cornerCurve = .continuous
        view.backgroundColor = UIColor(hex: "#F9f9f9")
        return view
    }()
    
    private var viewImage: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 6
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private var image: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: "square.and.arrow.up")
        image.tintColor = .white
        image.backgroundColor = .clear
        return image
    }()
    
    private var transName: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        label.textColor = .black
        label.isHidden = false
        return label
    }()
    
    private var purchasedData: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.textColor = .black
        return label
    }()
    
    private var priceLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(transactionData: TransactionModel, isHiddenData: Bool) {
        let currentData = Date.now.formatted().prefix(10)
        self.transName.text = transactionData.transactionName
        self.priceLabel.text = "$ \(transactionData.transactionAmount)"
        self.priceLabel.textColor = transactionData.transactionType == .income ? UIColor.shared.IncomeColor : UIColor.shared.ExpenseColor
        if isHiddenData {
            self.purchasedData.isHidden = true
        }else {
            self.purchasedData.isHidden = false
        }
        
        self.purchasedData.text = transactionData.transactionDate == currentData ? "Today" : String(transactionData.transactionDate.prefix(10))
    
        viewImage.backgroundColor = priceLabel.textColor
        image.image = transactionData.transactionType == .income ? UIImage(systemName: "square.and.arrow.down") : UIImage(systemName: "square.and.arrow.up")
    }
    
    override func layoutSubviews() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.left.right.equalToSuperview()
        }
        
        mainView.addSubview(viewImage)
        viewImage.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(10)
            make.size.equalTo(50)
        }
        
        viewImage.addSubview(image)
        image.snp.makeConstraints { make in
            make.left.top.bottom.right.equalToSuperview().inset(10)
        }
        
        mainView.addSubview(transName)
        transName.snp.makeConstraints { make in
            make.left.equalTo(viewImage.snp.right).offset(15)
            if self.purchasedData.isHidden {
                make.centerY.equalToSuperview()
            } else {
                make.top.equalTo(viewImage.snp.top)
            }
        }
        
        mainView.addSubview(purchasedData)
        purchasedData.snp.makeConstraints { make in
            make.left.equalTo(viewImage.snp.right).offset(15)
            make.bottom.equalTo(viewImage.snp.bottom)
        }
        
        mainView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
}
