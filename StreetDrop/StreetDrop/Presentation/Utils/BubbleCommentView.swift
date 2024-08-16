//
//  BubbleCommentView.swift
//  StreetDrop
//
//  Created by thoonk on 11/12/23.
//

import UIKit

import SnapKit
import RxSwift

final class BubbleCommentView: UIView {
    
    // MARK: - UI Components
    
    private lazy var commentContainerView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.gray50.cgColor
        view.layer.cornerRadius = 12
        
        view.layer.shadowColor = UIColor.gray50.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 10
        return view
    }()
    
    private lazy var commentContainerTailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "commentTail")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .gray50
        return imageView
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 14, weightName: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .gray700
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with comment: String) {
        commentLabel.text = comment
    }
}

private extension BubbleCommentView {
    func setupLayout() {
        
        // MARK: - Comment Container View
        
        self.addSubview(commentContainerView)
        commentContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // MARK: - Comment Label
        
        commentContainerView.addSubview(commentLabel)
        commentLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        // MARK: - Comment Container Tail ImageView
        
        self.addSubview(commentContainerTailImageView)
        commentContainerTailImageView.snp.makeConstraints {
            $0.width.equalTo(10)
            $0.height.equalTo(8)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(commentContainerView.snp.bottom).offset(6)
        }
    }
}
