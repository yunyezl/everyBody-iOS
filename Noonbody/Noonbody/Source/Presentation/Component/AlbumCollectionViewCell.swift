//
//  FolderCollectionViewCell.swift
//  everyBody-iOS
//
//  Created by 윤예지 on 2021/11/07.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    enum Style {
        case folder
        case album
    }
    
    // MARK: - UI Components
    
    private let thumbnailImageView = UIImageView().then {
        $0.makeRounded(radius: 4)
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = Asset.Color.gray20.color
    }
    private let folderTitleLabel = UILabel().then {
        $0.font = .nbFont(type: .body2SemiBold)
        $0.textColor = Asset.Color.gray90.color
    }
    private let descriptionLabel = UILabel().then {
        $0.font = .nbFont(type: .caption1)
        $0.textColor = Asset.Color.gray60.color
    }
    private let selectedView = SelectedView(style: .basic).then {
        $0.makeRounded(radius: 4)
    }
    private lazy var addImageView = UIImageView().then {
        $0.image = Asset.Image.add.image
        $0.contentMode = .scaleAspectFit
    }
    private lazy var addLabel = UILabel().then {
        $0.text = "폴더 생성"
        $0.font = .nbFont(type: .body2SemiBold)
    }
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.distribution = .fillEqually
    }
    
    // MARK: - Properties
    
    var style: Style?
    private var indexPath: IndexPath?
    
    override var isSelected: Bool {
        didSet {
            if case .folder = style {
                if getIndexPath()?.row != 0 {
                    isSelected ? setSelectedCell() : setUnselectedCell()
                }
            }
        }
    }
    
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewHierarchy()
        setupContraint()
        setupSkeletion()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        initCell()
    }
    
    // MARK: - Methods
    
    func initCell() {
        self.thumbnailImageView.image = nil
        self.descriptionLabel.text = ""
        self.folderTitleLabel.text = ""
    }
    
    func setupViewHierarchy() {
        contentView.addSubviews(thumbnailImageView, folderTitleLabel, descriptionLabel)
    }
    
    func setupContraint() {
        thumbnailImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(thumbnailImageView.snp.width)
        }
        
        folderTitleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func setSelectedCell() {
        addSubview(selectedView)
        
        selectedView.snp.makeConstraints {
            $0.edges.equalTo(thumbnailImageView)
        }
        
    }
    
    func setupSkeletion() {
        self.isSkeletonable = true
        [contentView, thumbnailImageView,
         folderTitleLabel, descriptionLabel].forEach { view in
                view.isSkeletonable = true
                view.skeletonCornerRadius = 4
        }
    }
    
    func setUnselectedCell() {
        selectedView.removeFromSuperview()
    }

    func setData(album: Album) {
        folderTitleLabel.text = album.name
        descriptionLabel.text = album.albumDescription
        
        if UserManager.hideThumbnail {
            thumbnailImageView.image = Asset.Image.privacyThumbnail.image
        } else {
            if let thumbnailURL = album.thumbnailURL {
                thumbnailImageView.image = AlbumManager.loadImageFromDocumentDirectory(from: thumbnailURL)
            } else {
                thumbnailImageView.image = Asset.Image.empty.image
            }
        }
    }
    
    func setFirstCell() {
        stackView.isHidden = false
        addSubview(stackView)
        stackView.addArrangedSubviews([addImageView, addLabel])
        
        stackView.snp.makeConstraints {
            $0.centerX.centerY.equalTo(thumbnailImageView)
        }
    }
    
    func setNoFirstCell() {
        stackView.isHidden = true
    }
    
    func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UICollectionView else { return nil }
        indexPath = superView.indexPath(for: self)
        return indexPath
    }
}
