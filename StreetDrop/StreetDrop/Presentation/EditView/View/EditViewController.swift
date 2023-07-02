//
//  EditViewController.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/07/02.
//

import UIKit

import SnapKit

// 드랍화면 재사용 (상속)
class EditViewController: MusicDropViewController {

    enum Constant {
        static let topLabelTitle = "수정하기"
        static let editButtonDisabledTitle = "수정하기"
        static let editButtonNormalTitle = "완료"
        static let empty = ""
    }

    private let viewModel: EditViewModel

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.topLabelTitle
        label.textColor = .gray100
        label.font = .pretendard(size: 16, weightName: .bold)

        return label
    }()

    init(viewModel: EditViewModel) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //ui
        self.dropButton.setTitle(Constant.editButtonDisabledTitle, for: .disabled)
        self.dropButton.setTitle(Constant.editButtonNormalTitle, for: .normal)
        self.backButton.setTitle(Constant.empty, for: .normal)
        self.dataSharingPermissionGuideLabel.isHidden = true
        self.locationLabel.isHidden = true
        self.commentTextView.text = viewModel.editInfo.content
        self.cancelButton.setTitle(Constant.empty, for: .normal)

        //configureLayout
        self.topView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }

        musicInfoStackView.snp.remakeConstraints {
            $0.top.equalTo(contentView).inset(24)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
