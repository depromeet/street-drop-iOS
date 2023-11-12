//
//  RecommendKeywordItemCell.swift
//  StreetDrop
//
//  Created by Jieun Kim on 2023/10/17.
//

import UIKit
import SnapKit

final class RecommendKeywordItemCell: UICollectionViewCell {
    static let cellIdentifier = "RecommendKeywordItemCell"
    
    private let tagLabel: PaddingLabel = {
        let label = PaddingLabel(padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        label.font = .pretendard(size: 16, weightName: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - layout
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(tagLabel)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 16
        
        tagLabel.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    func configure(data: RecommendMusicData) {
        self.tagLabel.text = data.text
        self.tagLabel.textColor = setTextColor(color: data.color)
        setBackgroundColor(color: data.color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTextColor(color: String) -> UIColor {
        switch color {
        case "RecommendKeywordHighLight":
            return UIColor.gray700
        case "RecommendKeywordBasic":
            return UIColor.gray150
        default:
            return UIColor.gray150
        }
    }
    
   private func setBackgroundColor(color: String) {
        switch color {
        case "RecommendKeywordHighLight":
            self.contentView.backgroundColor = .pointGradation_1
        case "RecommendKeywordBasic":
            self.contentView.backgroundColor = UIColor(red: 0.225, green: 0.225, blue: 0.225, alpha: 1)
        default:
            self.contentView.backgroundColor = UIColor(red: 0.225, green: 0.225, blue: 0.225, alpha: 1)
        }
    }
}
