//
//  NicknameEditViewController.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/07/10.
//

import UIKit

import RxCocoa
import RxRelay
import RxSwift
import SnapKit

final class NicknameEditViewController: UIViewController {
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bindAction()
    }
    
    // MARK: - UI
    
    private lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray900
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backButton")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.gray100
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .pretendard(size: 16, weightName: .bold)
        label.textColor = UIColor.gray100
        label.text = "닉네임 변경"
        return label
    }()
    
    private lazy var containerStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.font = .pretendard(size: 16, weightName: .medium)
        textField.textColor = UIColor.gray100
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 12
        textField.backgroundColor = UIColor.gray700
        
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = padding
        textField.rightView = padding
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        
        return textField
    }()
    
    private lazy var guideLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 14, weightName: .medium)
        label.textColor = UIColor.gray300
        label.text = "최소 1자에서 10자 이내로 입력해주세요"
        return label
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.setTitle("변경하기", for: .normal)
        button.titleLabel?.font = .pretendard(size: 16, weightName: .bold)
        button.backgroundColor = UIColor.gray400
        button.setTitleColor(UIColor.gray300, for: .normal)
        button.isEnabled = false
        return button
    }()
}

private extension NicknameEditViewController {
    
    // MARK: - UI
    
    func configureUI() {
        
        // MARK: - ViewController
        
        self.view.backgroundColor = UIColor.gray900
        
        // MARK: - Top View
        
        self.view.addSubview(topView)
        self.topView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(8)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(60)
        }
        
        // MARK: - Back Button
        
        self.topView.addSubview(backButton)
        self.backButton.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        // MARK: - Title Label
        
        self.topView.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        // MARK: - Container StackView
        
        self.view.addSubview(containerStackView)
        self.containerStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(24)
            make.top.equalTo(self.topView.snp.bottom).offset(8)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(8)
        }
        
        // MARK: - Nickname TextField
        
        self.containerStackView.addArrangedSubview(nicknameTextField)
        self.nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        // MARK: - Guide Label
        
        self.containerStackView.addArrangedSubview(guideLabel)
        
        // MARK: - Confirm Button
        
        self.containerStackView.addArrangedSubview(
            {
                let spacerView = UIView()
                spacerView.translatesAutoresizingMaskIntoConstraints = false
                spacerView.backgroundColor = UIColor.clear
                spacerView.setContentHuggingPriority(.defaultLow, for: .vertical)
                return spacerView
            }()
        )
        
        self.containerStackView.addArrangedSubview(confirmButton)
        self.confirmButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func enableConfirmButton() {
        confirmButton.backgroundColor = UIColor.gray400
        confirmButton.setTitleColor(UIColor.gray300, for: .normal)
        confirmButton.isEnabled = false
    }
    
    func validateNickname(_ nickname: String) {
        if nickname.count >= 1 && nickname.count <= 10 {
            nicknameTextField.layer.borderColor = UIColor.darkPrimary_25.cgColor
            guideLabel.textColor = UIColor.gray300
            
            confirmButton.backgroundColor = UIColor.primary500
            confirmButton.setTitleColor(UIColor.gray900, for: .normal)
            confirmButton.isEnabled = true
        } else {
            nicknameTextField.layer.borderColor = UIColor(red: 0.96, green: 0.44, blue: 0.41, alpha: 0.5).cgColor
            guideLabel.textColor = UIColor(red: 0.96, green: 0.44, blue: 0.41, alpha: 1)
            
            confirmButton.backgroundColor = UIColor.gray400
            confirmButton.setTitleColor(UIColor.gray300, for: .normal)
            confirmButton.isEnabled = false
        }
    }
    
    func disableConfirmButton() {
        confirmButton.backgroundColor = UIColor.gray400
        confirmButton.setTitleColor(UIColor.gray300, for: .normal)
        confirmButton.isEnabled = false
    }
    
    // MARK: - Bind Action
    
    func bindAction() {
        nicknameTextField.rx.text.orEmpty
            .subscribe(onNext: { [weak self] nickname in
                self?.validateNickname(nickname)
            })
            .disposed(by: disposeBag)
    }
}
