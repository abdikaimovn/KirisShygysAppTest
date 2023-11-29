//
//  QuoteCollectionViewCell.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 29.11.2023.
//

import UIKit

class QuoteCollectionViewCell: UICollectionViewCell {
    private let quotes = [
        QuoteModel(quote: "Money is not understood by many, even though many earn it and only a few master it.", author: "- Aiyaz Uddin"),
        QuoteModel(quote: "Like a well-nourished body, a healthy cash flow is essential for the vitality of your financial future.", author: "- Linsey Mill"),
        QuoteModel(quote: "When I was young I thought that money was the most important thing in life; now that I am old I know that it is", author: "- Oscar Wilde"),
        QuoteModel(quote: "The more we knew about the power of money, the more distant we grew from the teachers and our classmates", author: "– Robert Kiyosaki"),
        QuoteModel(quote: "People have got to learn: if they don’t have cookies in the cookie jar, they can’t eat cookies.", author: "- Suze Orman"),
        QuoteModel(quote: "If you want to be rich and maintain your wealth, it’s important to be financially literate, in words as well as numbers", author: "– Robert Kiyosaki"),
        QuoteModel(quote: "The number one problem in today’s generation and economy is the lack of financial literacy", author: "- Alan Greenspan"),
        QuoteModel(quote: "Intelligence solves problems and produces money. Money without financial intelligence is money soon gone", author: "- Robert Kiyosaki"),
        QuoteModel(quote: "Wise men learn by others harms, fools scarcely by their own.", author: "- Benjamin Franklin"),
        QuoteModel(quote: "A person either disciplines his finances or his finances discipline him", author: "- Orrin Woodward")
    ]
    
    private var monthQuoteLabel: UILabel = {
        var label = UILabel()
        label.text = "Quote of the month"
        label.textColor = UIColor(hex: "#F2F2F2")
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        return label
    }()
    
    private var quoteLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Italic", size: 30)
        label.numberOfLines = 0
        return label
    }()
    
    private var quoteAuthor: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let randomQuote = Int.random(in: 0...9)
        quoteLabel.text = quotes[randomQuote].quote
        quoteAuthor.text = quotes[randomQuote].author
        
        contentView.addSubview(monthQuoteLabel)
        monthQuoteLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(quoteLabel)
        quoteLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(monthQuoteLabel.snp.bottom).offset(50)
        }
        
        contentView.addSubview(quoteAuthor)
        quoteAuthor.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(quoteLabel.snp.bottom).offset(50)
        }
        
    }
    
}
