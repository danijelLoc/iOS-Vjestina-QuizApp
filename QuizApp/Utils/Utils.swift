//
//  Utils.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 06.05.2021..
//

import Foundation
import UIKit

public let backgroundColorLighter: UIColor = UIColor.init(hex:"#744FA3FF")!
public let backgroundColorDarker: UIColor = UIColor.init(hex:"#272F76FF")!
public let customRed:UIColor = UIColor(hex: "#FC6565FF")!
public let customGreen:UIColor = UIColor(hex: "#6FCF97FF")!
public let sectionColors:[UIColor] = [UIColor.yellow, UIColor(hex: "#56CCF2FF")!, UIColor.red, UIColor.green]

public let globalStackSpacing:CGFloat = 18.0
public let globalCornerRadius:CGFloat = 18

public let showPasswordImg = UIImage(named: "Show")?.withTintColor(.white, renderingMode: .alwaysOriginal)
public let hidePasswordImg = UIImage(named: "Hide")?.withTintColor(.white, renderingMode: .alwaysOriginal)


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


extension UIViewController{

    public func setGradientBackground(size: CGSize){
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        let largerAxis = max(size.height,size.width)
        gradientLayer.frame.size = CGSize(width: largerAxis, height: largerAxis)
        gradientLayer.colors = [backgroundColorLighter.cgColor,backgroundColorDarker.withAlphaComponent(1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        //Use diffrent colors
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}


extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
