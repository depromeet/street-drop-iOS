//
//  DropAnimationView.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/24.
//

import UIKit

final class DropAnimationView: UIView {

    //MARK: - UI

    // 디자인 요소 (레이아웃 잡힌 후 그라데이션 layer 적용)
    private lazy var topGradientCircleView: UIView = UIView()
    private lazy var smallerCenterGradientCircleView: UIView = UIView()
    private lazy var largerCenterGradientCircleView: UIView = UIView()

    private lazy var dropAnimationImageView: UIImageView = {
        let dropAnimationImage: UIImage = UIImage(named: "DropAnimationImage") ?? UIImage()
        let imageView = UIImageView(image: dropAnimationImage)
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    //MARK: - LifeCycle

    init() {
        super.init(frame: .zero)
        self.configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.makeViewIntoGradientCircle()
    }
}

private extension DropAnimationView {

    //MARK: - UI

    func configureUI() {
        self.clipsToBounds = true
        self.backgroundColor = .black

        [
            largerCenterGradientCircleView,
            smallerCenterGradientCircleView,
            topGradientCircleView,
            dropAnimationImageView
        ]
            .forEach {
                self.addSubview($0)
            }

        topGradientCircleView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(1.1)
            $0.height.equalTo(topGradientCircleView.snp.width)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.2)
        }

        smallerCenterGradientCircleView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(1.1)
            $0.height.equalTo(smallerCenterGradientCircleView.snp.width)
            $0.centerX.centerY.equalToSuperview()
        }

        largerCenterGradientCircleView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(1.4)
            $0.height.equalTo(largerCenterGradientCircleView.snp.width)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(1.1)
        }

        dropAnimationImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.4)
            $0.height.equalToSuperview().multipliedBy(0.4)
        }
    }
}

//MARK: - private
private extension DropAnimationView {

    //MARK: - 그라데이션 뷰

    func makeViewIntoGradientCircle() {
        topGradientCircleView.makeGradientCircleView(
            colors: [
                UIColor(red: 0.41, green: 0.94, blue: 0.97, alpha: 0).cgColor,
                UIColor(red: 0.41, green: 0.94, blue: 0.97, alpha: 0.1).cgColor
            ],
            gradientLocations: [0.53, 1],
            viewBackgroundColor: .clear,
            startPoint: CGPoint(x: 0.5, y: 0.0),
            endPoint: CGPoint(x: 0.5, y: 0.7)
        )

        smallerCenterGradientCircleView.makeGradientCircleView(
            colors: [
                UIColor(red: 0.41, green: 0.94, blue: 0.97, alpha: 0).cgColor,
                UIColor(red: 0.41, green: 0.94, blue: 0.97, alpha: 0.06).cgColor
            ],
            gradientLocations: [0.53, 1],
            viewBackgroundColor: .clear,
            startPoint: CGPoint(x: 0.5, y: 0),
            endPoint:  CGPoint(x: 0.5, y: 0.7)
        )

        largerCenterGradientCircleView.makeGradientCircleView(
            colors: [
                UIColor(red: 0.41, green: 0.94, blue: 0.97, alpha: 0).cgColor,
                UIColor(red: 0.41, green: 0.94, blue: 0.97, alpha: 0.04).cgColor,
            ],
            gradientLocations: [0.53, 1],
            viewBackgroundColor: .clear,
            startPoint: CGPoint(x: 0.5, y: 0),
            endPoint:  CGPoint(x: 0.5, y: 0.7)
        )
    }
}
