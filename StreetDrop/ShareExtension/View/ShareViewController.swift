//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by 차요셉 on 8/12/24.
//

import UIKit
import Social

import Kingfisher
import RxSwift
import RxRelay
import SnapKit

final class ShareViewController: SLComposeServiceViewController {
final class ShareViewController: UIViewController {
    private let viewModel: ShareViewModel = .init()
    private let disposeBag: DisposeBag = .init()
    private let sharedMusicKeyWordEvent: PublishRelay<String> = .init()
    
    override func isContentValid() -> Bool {
        return true
    }
    private let containerView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .gray800
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray600.cgColor
        
        return view
    }()
    
    private let villageNameLabel: UILabel = {
        let label: UILabel = .init()
        label.text = " "
        label.font = .pretendard(size: 16, weight: 700)
        label.textColor = .primary400
        label.setLineHeight(lineHeight: 24)
        
        return label
    }()
    
    private let changingMusicView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .gray600
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hexString: "#363840").cgColor
        
        let label: UILabel = .init()
        label.text = "원하는 음악이 아닌가요?"
        label.font = .pretendard(size: 14, weight: 500)
        label.textColor = .gray150
        label.setLineHeight(lineHeight: 20)
        
        let imageView: UIImageView = .init(image: .init(named: "next"))
        
        [label, imageView].forEach {
            view.addSubview($0)
        }
        label.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.top.equalToSuperview().inset(4)
            $0.leading.equalToSuperview().inset(10)
        }
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.top.equalToSuperview().inset(4)
            $0.trailing.equalToSuperview().inset(12)
        }
        
        return view
    }()
    
    private let belowArrow: UIImageView = {
        let imageView: UIImageView = .init(image: .init(named: "verctor"))
        
        return imageView
    }()
    
    private let albumCoverImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let songNameLabel: UILabel = {
        let label: UILabel = .init()
        label.text = " "
        label.font = .pretendard(size: 16, weight: 700)
        label.textColor = .textPrimary
        label.setLineHeight(lineHeight: 24)
        label.textAlignment = .center
        
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label: UILabel = .init()
        label.text = " "
        label.textColor = .gray400
        label.font = .pretendard(size: 12, weight: 400)
        label.setLineHeight(lineHeight: 16)
        label.textAlignment = .center
        
        return label
    }()

    override func didSelectPost() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        return []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureUI()
        
        // 공유된 데이터 가져오기
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem else { return }
        handleExtensionItem(extensionItem)
    }
    }
}

private extension ShareViewController {
    func bindViewModel() {
        let input: ShareViewModel.Input = .init(
            viewDidLoadEvent: .just(Void()),
            sharedMusicKeyWordEvent: sharedMusicKeyWordEvent.asObservable()
        )
        let output: ShareViewModel.Output = viewModel.convert(
            input: input,
            disposedBag: disposeBag
        )
        
        output.showVillageName
            .bind(with: self) { owner, villageName in
                owner.villageNameLabel.text = villageName
            }
            .disposed(by: disposeBag)
        
        output.showSearchedMusic
            .bind(with: self) { owner, music in
                owner.albumCoverImageView.kf.setImage(with: URL(string: music.albumImage))
                owner.songNameLabel.text = music.songName
                owner.artistNameLabel.text = music.artistName
            }
            .disposed(by: disposeBag)
    }
    
    func configureUI() {
        view.addSubview(containerView)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        containerView.snp.makeConstraints {
            $0.height.equalTo(596)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        [
            villageNameLabel,
            changingMusicView,
            belowArrow,
            albumCoverImageView,
            songNameLabel,
            artistNameLabel
        ].forEach {
            containerView.addSubview($0)
        }
        
        villageNameLabel.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.top.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
        
        changingMusicView.snp.makeConstraints {
            $0.width.equalTo(174)
            $0.height.equalTo(28)
            $0.top.equalTo(villageNameLabel.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
        }
        
        belowArrow.snp.makeConstraints {
            $0.width.equalTo(10)
            $0.height.equalTo(6)
            $0.top.equalTo(changingMusicView.snp.bottom)
            $0.centerX.equalTo(changingMusicView)
        }
        
        albumCoverImageView.snp.makeConstraints {
            $0.width.height.equalTo(85)
            $0.top.equalTo(belowArrow.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        songNameLabel.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.top.equalTo(albumCoverImageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
        }
        
        artistNameLabel.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.top.equalTo(songNameLabel.snp.bottom).offset(2)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}

// MARK: - Handle Shared Data
private extension ShareViewController {
    func handleExtensionItem(_ extensionItem: NSExtensionItem) {
        // ExtensionItem에서 ContentText 추출
        guard let sharedTextItem = extensionItem.attributedContentText,
              let videoID = extractVideoID(from: sharedTextItem.string) else { return }
        
        fetchVideoDetails(videoID: videoID) { [weak self] songName, artistName in
            self?.sharedMusicKeyWordEvent.accept("\(songName ?? "")-\(artistName ?? "")")
        }
    }
    
    func fetchVideoDetails(videoID: String, completion: @escaping (String?, String?) -> Void) {
        let apiKey = "AIzaSyDHsdIcuAK98-EW9UueCeF6g4iYiap7bmA" // YouTube Data API 키를 여기에 입력하세요
        let urlString = "https://www.googleapis.com/youtube/v3/videos?id=\(videoID)&key=\(apiKey)&part=snippet"
        
        guard let url = URL(string: urlString) else {
            completion(nil, nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let items = json["items"] as? [[String: Any]],
                   let snippet = items.first?["snippet"] as? [String: Any] {
                    let title = snippet["title"] as? String
                    let channelTitle = snippet["channelTitle"] as? String
                    completion(title, channelTitle)
                } else {
                    completion(nil, nil)
                }
            } catch {
                completion(nil, nil)
            }
        }
        task.resume()
    }
    
    func extractVideoID(from url: String) -> String? {
        guard let urlComponents = URLComponents(string: url),
              let queryItems = urlComponents.queryItems else {
            return nil
        }
        return queryItems.first(where: { $0.name == "v" })?.value
    }
}
