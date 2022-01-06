//
//  RecommendListViewController.swift
//  MyNetfilxPlayer
//
//  Created by sae hun chung on 2022/01/05.
//

import UIKit

class RecommendListViewController: UIViewController {
    
    @IBOutlet weak var sectionTitle: UILabel!
    
    let viewModel = RecommandListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        sectionTitle.text = viewModel.type.title
    }
}

extension RecommendListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as? RecommandCell else {
            return UICollectionViewCell()
        }
        
        let movie = viewModel.item(at: indexPath.item)
        cell.updateUI(movie: movie)
        return cell
    }
}

extension RecommendListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 160)
    }
}

class RecommandListViewModel {
    enum RecommandingType {
        case award
        case hot
        case my
        
        var title: String {
            switch self {
            case .award:
                return "아카데미 호평 영화"
            case .hot:
                return "취향저격 HOT 컨텐츠"
            case .my:
                return "내가 찜한 컨텐츠"
                
            }
        }
    }
    
    private (set) var type: RecommandingType = .my
    private var items: [DummyItem] = []
    
    var numOfItems: Int {
        return items.count
    }
    
    func item(at index: Int) -> DummyItem {
        return items[index]
    }
    
    func updateType(_ type: RecommandingType) {
        self.type = type
    }
    
    func fetchItems(){
        self.items = MovieFetcher.fetch(type)
    }
}

class RecommandCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    func updateUI(movie: DummyItem) {
        thumbnailImage.image = movie.thumbnail
    }
}

class MovieFetcher {
    static func fetch(_ type: RecommandListViewModel.RecommandingType) -> [DummyItem] {
        switch type {
        case .award:
            let movies = (1..<10).map{
                DummyItem(thumbnail: UIImage(named: "img_movie_\($0)")!)
            }
            return movies
        case .hot:
            let movies = (10..<19).map{
                DummyItem(thumbnail: UIImage(named: "img_movie_\($0)")!)
            }
            return movies
        case .my:
            let movies = (1..<10).map{ $0 * 2 }.map {
                DummyItem(thumbnail: UIImage(named: "img_movie_\($0)")!)
            }
            return movies
        }
    }
}

struct DummyItem {
    let thumbnail: UIImage
}
