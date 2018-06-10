import UIKit
import MudoxKit



class ExpandableTableViewController: UITableViewController {
  
  struct Section {
    
    struct Row {
      var isExpanded: Bool
      
      let title: String
      let message = """
        - Click to expand / shrink the cell.
        - When expanding, the message label is shown, cell height increases.
        - When shrink the cell, the message label is hidden, cell height decreases.
        """
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

  private var data: [Section] = {
    return (0..<(arc4random_uniform(7) + 3)).map { Section(title: "Section \($0)") }
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    with(tableView) { tv in
      tv.register(UITableViewCell.self, forCellReuseIdentifier: "sectionCell")
      tv.register(UINib(nibName: "ExpandableTableViewCell", bundle: nil), forCellReuseIdentifier: "rowCell")
      // self-sizing cell
      tv.rowHeight = UITableViewAutomaticDimension
      tv.estimatedRowHeight = 90
    }

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
    switch (indexPath.section, indexPath.row) {
    case let (section, row) where row == 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell", for: indexPath)
      cell.textLabel?.text = data[section].title
      return cell
    case let (section, row):
      let cell = tableView.dequeueReusableCell(withIdentifier: "rowCell", for: indexPath) as! ExpandableTableViewCell
      let item = data[section].rows[row - 1]
      cell.show(item)
      return cell
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch (indexPath.section, indexPath.row) {
    case let (section, row) where row == 0:
      data[section].isExpanded.toggle()
      tableView.reloadSections([section], with: .automatic)
    case let (section, row):
      data[section].rows[row - 1].isExpanded.toggle()
      tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
  }

//  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    if indexPath.row == 0 {
//      return 44
//    }
//
//    let isExpanded = data[indexPath.section].rows[indexPath.row - 1].isExpanded
//    return isExpanded ? 100 : 44
//  }
}
