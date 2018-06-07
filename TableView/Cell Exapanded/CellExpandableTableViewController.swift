import UIKit
import MudoxKit

fileprivate struct Section {

  struct Row {
    var isExpanded: Bool
    let title: String
  }

  var isExpanded = false
  let title: String
  var rows: [Row] = {
    return (0..<(arc4random_uniform(10) + 2)).map { row in
      return Row(isExpanded: false, title: "Row \(row)")
    }
  }()

  init(title: String) {
    self.title = title
  }
}

class CellExpandableTableViewController: UITableViewController {

  private var data: [Section] = {
    return (0..<(arc4random_uniform(7) + 3)).map { Section(title: "Section \($0)") }
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }

  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return data.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let section = data[section]
    if section.isExpanded {
      return 1 + section.rows.count
    } else {
      return 1
    }
  }


  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    if indexPath.row == 0 {
      cell.textLabel?.text = data[indexPath.section].title
      cell.indentationLevel = 0
    } else {
      cell.textLabel?.text = data[indexPath.section].rows[indexPath.row - 1].title
      cell.indentationLevel = 1
      cell.selectionStyle = .none
    }

    cell.separatorInset = UIEdgeInsets(top: 0, left: cell.indentationWidth * CGFloat(cell.indentationLevel), bottom: 0, right: 0)
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0 {
      data[indexPath.section].isExpanded.toggle()
      tableView.reloadSections([indexPath.section], with: .automatic)
    } else {
//      tableView.deselectRow(at: indexPath, animated: true)
      data[indexPath.section].rows[indexPath.row - 1].isExpanded.toggle()
      tableView.reloadRows(at: [indexPath], with: .automatic)
    }
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return 44
    }

    let isExpanded = data[indexPath.section].rows[indexPath.row - 1].isExpanded
    return isExpanded ? 100 : 44
  }
}
