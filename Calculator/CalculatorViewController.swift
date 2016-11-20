//
//  ViewController.swift
//  Calculator
//  Created by halley on 16/10/9.
//  Copyright © 2016年 Yang Mao. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet fileprivate weak var display: UILabel!
    
    @IBOutlet fileprivate weak var secondDisplay: UILabel!
    
    fileprivate var userIsInTheMiddleOfTyping = false
    fileprivate var userInputedDot = false
   
    var brain: CalculatorBrain = CalculatorBrain()
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show Graph" {
        let destinationvc = segue.destination
        if let graphvc = destinationvc as? GraphicsViewController{
            graphvc.title = brain.description as? String
            graphvc.program = brain.program
            
        }
    
    }
}
//        override func shouldPerformSegue(withIdentifier: String, sender: <#T##Any?#>)->{
//            if segue.identifier == "show Graph"{
//                return !brain.isPartialResult
//        }
    
    fileprivate var displayValue : Double{
        get{
        
            return Double(display.text!)!// maybe unconvertable
        }
        set{
            display.text = String(newValue)
        }
    }
    
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
        }
    
    @IBAction func restore() {
        allClear()//ViewContral和brain()中的数据都清除
        if (savedProgram != nil) {
        brain.program = savedProgram!
        print("saved\(savedProgram)")
        displayValue = brain.result
        showDescription()
        }
    }
    
    
    @IBAction fileprivate func dot(_ sender: UIButton) {
       
        if userIsInTheMiddleOfTyping && !userInputedDot {
            let textCurrentlyInDisplay = display.text!
                display.text = textCurrentlyInDisplay + "."
                userInputedDot = true
        }
    }
    
    @IBAction func setValue(_ sender: UIButton) {//setValue for M 也是一个Operation
//        if userIsInTheMiddleOfTyping {//判断下是不是一个数还没输完整
            //brain.setOperand(displayValue)
            //if let variableName = sender.currentTitle{
            brain.variableValues["M"] = displayValue
            userIsInTheMiddleOfTyping = false
            userInputedDot = false
            print("(getM)\(brain.variableValues)")
        
            if (brain.sizeOfInternalProgram>0){
            brain.updateByInternalProgram();
            displayValue = brain.result
            showDescription()
        }
            brain.lastOp = brain.VARIABLE

            //secondDisplay.text! = brain.description as! String//输入了一个操作符，description里面要显示出来
//        }
        
    }

    @IBAction fileprivate func performOperation(_ sender: UIButton) {//输入操作符
        if userIsInTheMiddleOfTyping {//判断下是不是一个数还没输完整(其实就能判断上一个输入的是不是数字了)
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
            userInputedDot = false
            showDescription()
            //secondDisplay.text! = brain.description as! String//输入了一个操作符，description里面要显示出来
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
            showDescription()
            //secondDisplay.text! = brain.description as! String
            if brain.isPartialResult {
                secondDisplay.text!+="..."
            }
        }
        
        displayValue = brain.result
    }
    
    @IBAction fileprivate func touchDigit(_ sender: UIButton) { // 输入数字
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {// prefer userAlreadyStartTyping
            let textCurrentlyInDisplay = display.text
            display.text=textCurrentlyInDisplay! + digit
        } else {
            display.text=digit
            if !brain.isPartialResult {
                brain.clearExceptInternalProgram()//#Assign1.h
                //brain.isPartialResult = true
            }
        }
        userIsInTheMiddleOfTyping = true//一个数的输完了
    }

    @IBAction func variablesSymbol(_ sender: UIButton) {//各司其职，他是个超级复合体
       
        if let variableName = sender.currentTitle {
            print("Touch MMMMMM")
            brain.setOperand(variableName)
            if let tmp = brain.variableValues[variableName] {
                display.text! = String(tmp)
            }
//          display.text! = brain.variableValues[variableName] as! String 这样不行，unwrap 必须按照上面来
            showDescription()
        

            userInputedDot = false
            userIsInTheMiddleOfTyping = false
        }
        
    }
    
    @IBAction func backSpace() {
        brain.backSpace()
        displayValue = brain.result
        if brain.sizeOfInternalProgram == 0 {
            userIsInTheMiddleOfTyping = false //避免删完数输数字变成0.09
        }
        showDescription()
    }
    
    
    func showDescription() {// leave it here
       secondDisplay.text! = brain.description as! String
    }

    @IBAction func allClear() {
        brain.allClear()
        userIsInTheMiddleOfTyping = false
        userInputedDot = false
        displayValue = 0
        secondDisplay.text! = String(0)
    }
    

    
}


 
