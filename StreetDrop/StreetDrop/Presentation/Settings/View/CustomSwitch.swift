//
//  CustomSwitch.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/07/16.
//

import UIKit

import RxRelay
import SnapKit

final class CustomSwitch: UIControl {
    let switchEvent: PublishRelay<Void> = .init()
    private enum Constant {
        static let duration = 0.25
    }
    
    private let barView: RoundableView = {
        let view = RoundableView()
        view.backgroundColor = .gray600
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let circleView: RoundableView = {
        let view = RoundableView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var isOn = false {
        didSet {
            switchEvent.accept(Void())
            self.sendActions(for: .valueChanged)
            
            UIView.animate(
                withDuration: Constant.duration,
                delay: 0,
                options: .curveEaseInOut,
                animations: {
                    self.barView.backgroundColor = self.isOn ? .darkPrimary_700 : .gray600
                    
                    self.circleView.snp.removeConstraints()
                    if self.isOn {
                        self.circleView.snp.makeConstraints {
                            $0.centerY.equalToSuperview()
                            $0.width.height.equalTo(24)
                            $0.right.equalToSuperview().inset(2)
                        }
                    } else {
                        self.circleView.snp.makeConstraints {
                            $0.centerY.equalToSuperview()
                            $0.width.height.equalTo(24)
                            $0.left.equalToSuperview().inset(2)
                        }
                    }
                    self.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("xib is not implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.isOn = !self.isOn
    }
}

private extension CustomSwitch {
    func configureUI() {
        self.addSubview(self.barView)
        self.barView.addSubview(self.circleView)
        
        self.barView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

final class RoundableView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
}
