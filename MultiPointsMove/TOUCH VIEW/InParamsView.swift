//
//  MPMInParamsView.swift
//  MultiPointsMove
//
//  Created by 尚雷勋 on 2020/9/6.
//

import UIKit
import SnapKit

class MPMInParamCell: UITableViewCell {
    
    public static let identifier = "MPMInParamCell"
    
    var inTextView: UITextField?
    var unitText: UILabel?
    
    private var inTextBlock: ( (_ text: String) -> Void )?
    private var beginEditBlock: ( (_ tf: UITextField) -> Void )?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        inTextView = UITextField()
        unitText = UILabel()
        unitText?.frame = .make(0, 0, 40, 40)
        unitText?.textAlignment = .center
        unitText?.font = UIFont(name: "ArialRoundedMTBold", size: 17)
        
        let rvContentView = UIView(frame: .make(0, 0, 40, 40))
        rvContentView.addSubview(unitText!)
        
        inTextView?.borderStyle = .roundedRect
        inTextView?.rightView = rvContentView
        inTextView?.rightViewMode = .always
        inTextView?.delegate = self
        
        contentView.addSubview(inTextView!)
        
        inTextView?.snp.makeConstraints({ (make) in
            
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16.0)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalToSuperview().multipliedBy(0.7)
            
        })
        
        
        inTextView?.addTarget(self, action: #selector(inTextValueDidChange(_:)), for: .editingChanged)
        
        
    }
    
    func setInTextBlock(_ handler: @escaping (_ text: String) -> Void ) {
        inTextBlock = handler
        
    }
    
    func setBeginEditBlock(_ handler: @escaping (_ tf: UITextField) -> Void ) {
        beginEditBlock = handler
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func inTextValueDidChange(_ sender: UIView) {
        
        if let tf = sender as? UITextField,
           let txt = tf.text {
            inTextBlock?(txt)
        }
    }
    
    
}

extension MPMInParamCell: UITextFieldDelegate {
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        beginEditBlock?(textField)
        
        return true
    }
}

class MPMInParamsView: UIView {
    
    var tableView: UITableView!
    var toolbar: UIToolbar?
    
    private var tcsize: CGSize = .zero
    
    let dataSource = [ "basic": [ "fFrontWarnDistance", "nCarDirectionInImage", "nVerticalLine", "nHorizontalLine"],
                       "alert areas width": [ "first", "second", "third" ],
                       "camera params": [ "focal length", "sensor size", "inst height" ] ]
    
    let keys = [ "basic", "alert areas width", "camera params" ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTableView()
        addToolbar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func keyboardWillShow(_ notif: Notification) {
        
        if let isMyKeyboard = notif.userInfo?[UIResponder.keyboardIsLocalUserInfoKey] as? Bool,
           let keyboardFrame = notif.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            
            if isMyKeyboard {

                var insets = tableView.contentInset
                let csize = tableView.contentSize
                
                tcsize = csize

                let inseth = keyboardFrame.height

                insets = UIEdgeInsets(top: insets.top, left: insets.left, bottom: inseth, right: insets.right)

                
                tableView.contentInset = insets

                print("keyboard show: tableview contentsize:\(tableView.contentSize)")

            }
        }
    }
    
    @objc func keyboardWillHide(_ notif: Notification) {
        
        tableView.contentInset = .zero
        
        print("keyboard hide: tableview contentsize:\(tableView.contentSize)")

    }
    
    func addTableView() {
        
        
        tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.register(MPMInParamCell.self, forCellReuseIdentifier: MPMInParamCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.keyboardDismissMode = .interactive
        tableView.contentInsetAdjustmentBehavior = .always
        
        tableView.tableFooterView = UIView()
        
        
        addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    func addToolbar() {
        
        toolbar = UIToolbar(frame: .make(0, 0, UIScreen.width(), 40))
        toolbar?.barStyle = .default
        
        toolbar?.items = [
            UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNumberPad)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneWithNumberPad)) ]
        
        toolbar?.sizeToFit()
        
        
    }
    
    @objc func cancelNumberPad() {
        
    }
    
    @objc func doneWithNumberPad() {
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension MPMInParamsView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let key = keys[section]
        
        return dataSource[key]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: MPMInParamCell.identifier, for: indexPath) as? MPMInParamCell {
            
            let key = keys[indexPath.section]
            
            
            cell.textLabel?.text = dataSource[key]?[indexPath.row]
            
            cell.setBeginEditBlock { [weak self] (tf) in
                
                tf.inputAccessoryView = self?.toolbar
            }
            
            
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
