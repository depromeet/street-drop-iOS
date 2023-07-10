//
//  EditViewController.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/07/02.
//

import UIKit

import RxSwift
import RxCocoa
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
    private let viewDidLoadEvent = PublishRelay<Void>()
    private let tapEditButtonEvent = PublishRelay<String>()
    private let disposeBag = DisposeBag()

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

        configureUI()
        bindAction()
        bindViewModel()
        viewDidLoadEvent.accept(())
    }
}

private extension EditViewController {
    
    // MARK: - Action Binding

    func bindAction() {
        self.dropButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }

                self.tapEditButtonEvent.accept(self.commentTextView.text)
            }).disposed(by: disposeBag)

        backButton.rx.tap
            .bind(onNext: { [weak self] in
                guard self?.viewModel.state == .edit else { return }
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }

    // MARK: - Data Binding

    func bindViewModel() {
        let input = EditViewModel.Input(
            viewDidLoadEvent: self.viewDidLoadEvent.asObservable(),
            tapEditButtonEvent: self.tapEditButtonEvent.asObservable()
        )

        let output = viewModel.convert(input: input, disposedBag: disposeBag)

        output.comment
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] comment in
                self?.commentTextView.text = comment
            }).disposed(by: disposeBag)

        output.dismiss
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }

    //MARK: - UI

    func configureUI() {
        self.cancelButton.setTitle(Constant.empty, for: .normal)
        self.dropButton.setTitle(Constant.editButtonDisabledTitle, for: .disabled)
        self.dropButton.setTitle(Constant.editButtonNormalTitle, for: .normal)
        self.backButton.setTitle(Constant.empty, for: .normal)
        self.locationLabel.isHidden = true
        self.cancelButton.setTitle(Constant.empty, for: .normal)

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
