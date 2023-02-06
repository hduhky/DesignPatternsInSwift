import XCTest

class StrategyRealWorld: XCTestCase {

    /// This example shows a simple implementation of a list controller that is
    /// able to display models from different data sources:
    ///
    /// (MemoryStorage, CoreDataStorage, RealmStorage)

    func test() {

        let controller = ListController()

        let memoryStorage = MemoryStorage<StrategyUser>()
        memoryStorage.add(usersFromNetwork())

        clientCode(use: controller, with: memoryStorage)

        clientCode(use: controller, with: CoreDataStorage())

        clientCode(use: controller, with: RealmStorage())
    }

    func clientCode(use controller: ListController, with dataSource: DataSource) {

        controller.update(dataSource: dataSource)
        controller.displayModels()
    }

    private func usersFromNetwork() -> [StrategyUser] {
        let firstUser = StrategyUser(id: 1, username: "username1")
        let secondUser = StrategyUser(id: 2, username: "username2")
        return [firstUser, secondUser]
    }
}

class ListController {

    private var dataSource: DataSource?

    func update(dataSource: DataSource) {
        /// ... resest current states ...
        self.dataSource = dataSource
    }

    func displayModels() {

        guard let dataSource = dataSource else { return }
        let models = dataSource.loadModels() as [StrategyUser]

        /// Bind models to cells of a list view...
        print("\nListController: Displaying models...")
        models.forEach({ print($0) })
    }
}

protocol DataSource {

    func loadModels<T: StrategyDomainModel>() -> [T]
}

class MemoryStorage<Model>: DataSource {

    private lazy var items = [Model]()

    func add(_ items: [Model]) {
        self.items.append(contentsOf: items)
    }

    func loadModels<T: StrategyDomainModel>() -> [T] {
        guard T.self == StrategyUser.self else { return [] }
        return items as! [T]
    }
}

class CoreDataStorage: DataSource {

    func loadModels<T: StrategyDomainModel>() -> [T] {
        guard T.self == StrategyUser.self else { return [] }

        let firstUser = StrategyUser(id: 3, username: "username3")
        let secondUser = StrategyUser(id: 4, username: "username4")

        return [firstUser, secondUser] as! [T]
    }
}

class RealmStorage: DataSource {

    func loadModels<T: StrategyDomainModel>() -> [T] {
        guard T.self == StrategyUser.self else { return [] }

        let firstUser = StrategyUser(id: 5, username: "username5")
        let secondUser = StrategyUser(id: 6, username: "username6")

        return [firstUser, secondUser] as! [T]
    }
}

protocol StrategyDomainModel {

    var id: Int { get }
}

struct StrategyUser: StrategyDomainModel {

    var id: Int
    var username: String
}
