//
//  InputField.swift
//  QuizApp
//
//  Created by Five on 13.04.2021..
//

import Foundation
import UIKit

class InputField : UITextField{
    
    private let globalCornerRadius:CGFloat = 18
    private let textFieldPadding:CGFloat = 22
    private var isProtected:Bool!
    private var selectionListeners:Set<InputField>!
    private var emptinessListeners:Set<Button>!
    private var invalid:Bool = false
    
    required init ?(coder: NSCoder ) {
        fatalError ( "init(coder:) has not been implemented" )
    }
    
    init(placeHolder: String, isProtected: Bool){
        super.init(frame: CGRect.zero)
        self.attributedPlaceholder =
            NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.selectionListeners = []
        self.emptinessListeners = []
        self.isProtected = isProtected
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.style()
    }
    
    func style(){
        
        self.backgroundColor = .white
        self.textColor = .white
        self.backgroundColor! = self.backgroundColor!.withAlphaComponent(0.3)
        if self.isProtected {
            self.isSecureTextEntry = true
        }
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.layer.cornerRadius = globalCornerRadius
        self.clipsToBounds = true
        self.setLeftPaddingPoints(textFieldPadding)
        self.setRightPaddingPoints(textFieldPadding)
        self.layer.borderColor = UIColor.white.cgColor
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // if selected TODO
        super.touchesBegan(touches, with: event)
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.notifySelectionListeners()
    }
    
    @objc func textFieldDidChange(){
        if self.text?.isEmpty != true {
            notifyEmptinessListeners(isEmpty: false)
        }else{
            notifyEmptinessListeners(isEmpty: true)
        }
    }
    
    func otherFieldSelected() {
        self.layer.borderWidth = 0
    }
    
    public func addSelectionListener(inputField:InputField){
        self.selectionListeners.insert(inputField)
    }
    
    public func addEmptinessListener(button:Button){
        self.emptinessListeners.insert(button)
    }
    
    public func showInvalid(){
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1

    }
    
    func notifySelectionListeners(){
        for listener in self.selectionListeners {
            listener.otherFieldSelected()
        }
    }
    
    func notifyEmptinessListeners(isEmpty:Bool){
        // provjeri stanje drugih polja
        if(!isEmpty){
            var noEmptyFields = true
            for input in self.selectionListeners {
                if input.text?.isEmpty == true {
                    noEmptyFields = false
                }
            }
            if noEmptyFields {
                for listener in self.emptinessListeners{
                    listener.enable()
                }
            }
        }else{
            for listener in self.emptinessListeners{
                listener.disable()
            }
        }
    }
    
    
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


