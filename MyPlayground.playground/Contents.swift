import PlaygroundSupport
import UIKit
import RxSwift
import RxRelay

class ViewModel: Hashable {
    let id = UUID()
    let text = BehaviorRelay<String>(value: "Some text")

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
        lhs.id == rhs.id
    }
}

class Cell: UICollectionViewListCell {
    var reusableDisposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        reusableDisposeBag = DisposeBag()
    }
}

class ViewController: UICollectionViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, ViewModel>

    lazy var dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        itemIdentifier.text.bind { text in
//            cell.defa
        }
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(Cell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = dataSource
    }
}

PlaygroundPage.current.liveView = ViewController()
PlaygroundPage.current.needsIndefiniteExecution = true
