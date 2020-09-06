//
//  InputView.swift
//  EightPointMove
//
//  Created by 尚雷勋 on 2020/9/6.
//

import UIKit
import SnapKit

class InputCell: UITableViewCell {
    
    public static let identifier = "InputCell"
    
    var inputText: UITextField?
    var unitText: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        inputText = UITextField()
        unitText = UILabel()
        unitText?.frame = .make(0, 0, 40, 40)
        unitText?.textAlignment = .center
        unitText?.font = UIFont(name: "ArialRoundedMTBold", size: 17)
        
        let rvContentView = UIView(frame: .make(0, 0, 40, 40))
        rvContentView.addSubview(unitText!)
        
        
        inputText?.borderStyle = .roundedRect
        
        contentView.addSubview(inputText!)
        
        
        inputText?.snp.makeConstraints({ (make) in
            
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16.0)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalToSuperview().multipliedBy(0.7)
            
        })
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class InputView: UIView {
    
    var tableView: UITableView!
    
    let dataSource = [ "basic": [ "visiable length", "horiz Y", "vertical X"],
                       "alert areas width": [ "first", "second", "third" ],
                       "camera params": [ "focal length", "sensor size" ] ]
    
    let keys = [ "basic", "alert areas width", "camera params" ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTableView() {
        
        
        tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.register(InputCell.self, forCellReuseIdentifier: InputCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
        
        
        addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        
    }
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension InputView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let key = keys[section]
        
        return dataSource[key]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: InputCell.identifier, for: indexPath) as? InputCell {
            
            let key = keys[indexPath.section]
            
            
            cell.textLabel?.text = dataSource[key]?[indexPath.row]
            
            
            return cell
            
        }
        
        return UITableViewCell()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        dataSource.keys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return keys[section]
    }
    
}
