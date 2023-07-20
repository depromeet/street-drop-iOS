//
//  SettingElementView.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/06/13.
//

import UIKit

import RxRelay
import SnapKit

class SettingElementView: UIView {
    let settingElementDidTappedEvent: PublishRelay<Void> = .init()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    var text: String {
        get{
            return InfoLabel.text ?? ""
        }
        set {
            InfoLabel.text = newValue
        }
    }
    
    private lazy var InfoLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .pretendard(size: 14, weightName: .medium)
        label.setLineHeight(lineHeight: 20)
        label.textColor = .gray100
        label.numberOfLines = 1
        
        return label
    }()
    
    private let goOutImageView: UIImageView = {
        let imageView: UIImageView = .init(image: UIImage(named: "goOut"))
        
        return imageView
    }()
    
    func setData(text: String) {
        self.InfoLabel.text = text
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        settingElementDidTappedEvent.accept(Void())
    }
}

private extension SettingElementView {
    func configureUI() {
        self.layer.cornerRadius = 12
        self.backgroundColor = .gray800
        
        [
            self.InfoLabel,
            self.goOutImageView
        ].forEach {
            self.addSubview($0)
        }
        
        self.InfoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        self.goOutImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.InfoLabel.snp.trailing).offset(4)
        }
    }
}
