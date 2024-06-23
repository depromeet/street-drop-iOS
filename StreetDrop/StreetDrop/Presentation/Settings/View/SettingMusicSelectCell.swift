//
//  SettingMusicSelectCell.swift
//  StreetDrop
//
//  Created by jihye kim on 15/06/2024.
//

import RxSwift
import UIKit

class SettingMusicSelectCell: UICollectionViewCell {
    private let disposeBag = DisposeBag()
    private var musicAppButtons: [MusicAppButton] = []
    private var onMusicAppSelected: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    private lazy var infoLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .pretendard(size: 14, weightName: .medium)
        label.setLineHeight(lineHeight: 20)
        label.textColor = .gray100
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var selectingMusicAppStackView: UIStackView = {
        let stackView: UIStackView = .init()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        MusicApp.allCases.forEach { musicApp in
            let button: MusicAppButton = .init()
            button.setData(musicApp: musicApp)
            button.rx.controlEvent(.touchUpInside)
                .bind { [weak self] in
                    self?.onMusicAppSelected?(musicApp.queryString)
                }
                .disposed(by: disposeBag)
                
            musicAppButtons.append(button)
        }
        musicAppButtons.forEach {
            stackView.addArrangedSubview($0)
        }
        
        return stackView
    }()
    
    func configure(
        with item: SettingItem,
        selectedMusicApp: MusicApp,
        onMusicAppSelected: ((String) -> Void)?
    ) {
        infoLabel.text = item.title
        musicAppButtons.forEach { button in
            button.musicApp == selectedMusicApp
            ? button.setSelectedAppearance()
            : button.setUnselectedAppearance()
        }
        self.onMusicAppSelected = onMusicAppSelected
    }
}

private extension SettingMusicSelectCell {
    private func configureUI() {
        self.layer.cornerRadius = 12
        self.backgroundColor = .gray800
        
        [
            self.infoLabel,
            self.selectingMusicAppStackView
        ].forEach {
            self.contentView.addSubview($0)
        }
        
        self.infoLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
        }
        
        self.selectingMusicAppStackView.snp.makeConstraints {
            $0.top.equalTo(self.infoLabel.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }
}
