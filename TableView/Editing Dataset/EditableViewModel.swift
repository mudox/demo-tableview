import RxSwift
import RxCocoa

import JacKit
fileprivate let jack = Jack.usingLocalFileScope().setLevel(.verbose)

struct EditableViewModel {

  typealias Item = String

  let items: [Item]

  init(items: [Item]) {
    self.items = items
  }

  enum Command {
    case setItems([Item])
    case addItem(Item)
    case deleteItemAt(IndexPath)
    case moveItem(from: IndexPath, to: IndexPath)

    static var refreshItems: Command {
      let count = 20 + arc4random_uniform(10)
      let items = (0..<count).map { "Item \($0)" }
      return .setItems(items)
    }
  }

  func execute(_ command: Command) -> EditableViewModel {
    
    switch command {
    case .setItems(let items):
      return EditableViewModel(items: items)
    case .addItem(let item):
      var items = self.items
      items.append(item)
      return EditableViewModel(items: items)
    case .moveItem(let from, let to):
      var items = self.items
      items.insert(items.remove(at: from.row), at: to.row)
      return EditableViewModel(items: items)
    case .deleteItemAt(let indexPath):
      var items = self.items
      items.remove(at: indexPath.row)
      return EditableViewModel(items: items)
    }

  }

}
