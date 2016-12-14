//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by halley on 16/10/16.
//  Copyright © 2016年 Yang Mao. All rights reserved.
//

import Foundation

class CalculatorBrain{
    
    let NULL = 0
    let NUMBER = -1
    let CONSTANT = 1
    let UNARY = 2
    let BINARY = 3
    let EQUALS = 4
    let VARIABLE = 5


    fileprivate var accumulator = 0.0
    fileprivate var internalProgram = [AnyObject]()
    fileprivate var looksLike = [AnyObject]()//这个是internalProgram的展示形式，多了些括号什么的
    fileprivate var equalsInputed = false
    fileprivate var pending: PendingBinaryOperationInfo?
    
    var isPartialResult = false // 感觉我的lastOp功能更强大
    var variableValues : Dictionary<String, Double> = [:]
    var lastOp = 0// 用户指示上一个输入的操作数或操作服符类型，0 表示初始或者未知，(－1表数字，1表示常量)， 2表示Unary，3表示Binary，4表示Equals,5表示variabel, 6表示ASSIGNMENT          TODO只记符号
    
    
    var description : PropertyList {//description 只是一个临时用于把lookslike中内容读出来的String
        get {
            var tmp = ""
            for op in looksLike{
                if let operand = op as? Double{
                    tmp += String(operand)
                }
                if let operation = op as? String{
                    tmp += String(operation)
                }
            }
            return tmp as CalculatorBrain.PropertyList
        }
    }
    
    
    func setOperand (_ operand: Double) {//获得 运算数
            accumulator = operand
            looksLike.append(operand as AnyObject)
            //print ("(operand)[looksLike]\(looksLike)")
            internalProgram.append(operand as AnyObject)
            //print ("(operand)[internalProgram]\(internalProgram)")
            if (isPartialResult) {
                isPartialResult = false
            }
            lastOp = NUMBER
     }
    
    
    func setOperand(_ variableName: String){
        //print("variableValue\(variableValues)")
        if variableValues[variableName] == nil {accumulator = 0.0}
        else {
            accumulator = variableValues [variableName]!
            //print("accumlator====\(accumulator)")
        }
        looksLike.append(variableName as AnyObject)
        //print ("(variableName)}to[looksLike]"+String(describing: looksLike))
        internalProgram.append(variableName as AnyObject)
        //print ("(variableName)[internalProgram]"+String(describing: internalProgram))
        if (isPartialResult){
            isPartialResult = false
        }
        lastOp = VARIABLE
}

    
    fileprivate var operations: Dictionary<String,Operation> = [//这里的Operation是下面的枚举类型,然后这边定义的只是一个Dictionary
        "π" : Operation.constant(M_PI),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),  //sqrt
        "cos" : Operation.unaryOperation(cos), // cos
        "sin" : Operation.unaryOperation(sin),
        "×" : Operation.binaryOperation({ $0 * $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        "-" : Operation.binaryOperation({ $0 - $1 }),
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "±" : Operation.unaryOperation({ 0 - $0}),
        "%" : Operation.unaryOperation({ $0 / 100}),
        "=" : Operation.equals,
    
    ]
    fileprivate enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)//这个括号里面是了一个函数类型，把它当作int 和 double 理解就好
        case binaryOperation((Double,Double) -> Double)
        case equals
    }
    func performOperation(_ symbol: String) {//进行运算
        
        internalProgram.append(symbol as AnyObject)
        //print ("(brain.performOperation)[internalProgram]\(internalProgram)")
        if let operation = operations[symbol] {
            
            switch operation {
            case .constant(let associatedConstantValue):
                accumulator = associatedConstantValue
                if (lastOp == NUMBER)||(lastOp == CONSTANT){
                    looksLike.remove(at: looksLike.count-1)
                }
                looksLike.append(symbol as AnyObject)
                lastOp = CONSTANT
            case .unaryOperation(let function)://associatedFunction 这个函数是从字典里获取来的，这歌funciton 就是定义了一个函数的意思
                accumulator = function(accumulator)
                //往前回溯，直到遇到符号(找到最近的符号),（括号不算符号），是等号，则把前面的都圈起来，如果不是，就只圈附近的  TODO! 7+8=9sqrt
                var index=looksLike.count-1;
                if index>0 {
                    while (index>0)&&((looksLike[index] is Double)||(looksLike[index] as! String == "M")||(looksLike[index] as! String=="(")||(looksLike[index] as! String==")")){
                    index -= 1
                    }
                        if  String(describing: looksLike[index]) == "=" {
                            looksLike.insert("(" as AnyObject,at: 0)
                            looksLike.insert(symbol as AnyObject,at: 0)
                            looksLike.insert(")" as AnyObject,at: looksLike.count-1)
                            //在开通查括号，等号前面差括号
                        }
                        else {
                            looksLike.insert("(" as AnyObject,at: index+1)
                            looksLike.insert(symbol as AnyObject,at: index+1)
                            looksLike.insert(")" as AnyObject,at: looksLike.count)
                                //在数字前插新操作符和括号，在数字后插括号
                    }
                }
                else if index==0{
                        looksLike.insert("(" as AnyObject,at: index)
                        looksLike.insert(symbol as AnyObject,at: index)
                        looksLike.insert(")" as AnyObject,at: looksLike.count)
                    }
                lastOp = UNARY
                
            
            case .binaryOperation(let function):
                executePendingBinaryOperation()
                //print("unaryOP accumulator=\(accumulator)")
                isPartialResult = true//!!这个我都没用到
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)//这是个结构体，把function 和 accumlator放进去了
                //print("pending=\(pending)")
                looksLike.append(symbol as AnyObject)
                //print("lookslike====\(looksLike)")
                if equalsInputed {
                    replaceEquals()
                }
                lastOp = BINARY
                
                
            case .equals:
                executePendingBinaryOperation()
                if equalsInputed {
                    replaceEquals()
                } else {
                looksLike.append(symbol as AnyObject)
                equalsInputed = true
                }
                lastOp = EQUALS
                isPartialResult = false
                
            }
            
        }
}
    fileprivate func executePendingBinaryOperation(){//这个函数就是 我认为的 输入过程中的小等号
        //print("pending===\(pending)")
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)//原来是在这边执行了加号和乘号
            if isPartialResult {
                looksLike.append(pending!.firstOperand as AnyObject)//这里修正来Assigh1.j的问题
                isPartialResult = false//这里同上，另外我觉得iPartialResult比我那个简洁

            }
            else {isPartialResult = true}
            pending = nil//pending用完，保存在pending中的函数第一个操作数都被用完了；具体的第一个操作数和第二个操作数相乘请看 上面一行和两行
                    }
    }
    fileprivate struct PendingBinaryOperationInfo{
        var binaryFunction:(Double, Double) -> Double//这个括号里面是了一个函数类型，把它当作int 和 double 理解就好，binaryFuntion就是将要操作的有两个操作数的函数
        var firstOperand: Double
    }
    
    typealias PropertyList = AnyObject
    
    var program : PropertyList{//这个Program只是internalProgram给ViewContral提供API
        get{
            return internalProgram as CalculatorBrain.PropertyList
        }
        set{
            allClear()
            if let arrayOfOps = newValue as? [AnyObject]{
                for op in arrayOfOps{//这个for循环相当于把刚刚的动作全部重新做了一遍
                    //print("op====\(op)")
                    if let operand = op as? Double {
                        setOperand(operand)
                    }
                    if let operationOrVariableName = op as? String {
                        if ((variableValues[operationOrVariableName]) != nil) {setOperand(operationOrVariableName)}
                        else {performOperation(operationOrVariableName)}
                    }
                }
            }
        }
    }
    fileprivate func replaceEquals(){
        for (index,op) in looksLike.enumerated() {
            if String(describing: op) == "=" {
            looksLike.remove(at: index)
            }
        }
        looksLike.append("=" as AnyObject)//找出原来的equals,并且替换掉
    }
    func allClear(){//按下AC键的，清理掉所有东西包括internalProgram，因为已经存储在ViewControl中了
        accumulator = 0.0
        pending = nil
        equalsInputed = false
        looksLike.removeAll()
        isPartialResult = false
        lastOp = NULL
        internalProgram.removeAll()
    }
    func clearExceptInternalProgram(){
        accumulator = 0.0
        pending = nil
        equalsInputed = false
        looksLike.removeAll()
        isPartialResult = false
        lastOp = NULL
    }
    var result: Double {
        get {
            return accumulator
        }
    }
    func updateByInternalProgram(){
        var tmp :PropertyList
        tmp = program
        //print("tmptmp=====\(tmp)")
        program = tmp
    }
    func backSpace(){
        clearExceptInternalProgram()
        if (!internalProgram.isEmpty){
            internalProgram.removeLast()
            updateByInternalProgram()
        }
    }
    var sizeOfInternalProgram : Int{
        get{
            return internalProgram.count
        }
    }
}
