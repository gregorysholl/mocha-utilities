//
//  CPFUtil.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 11/06/17.
//
//

import UIKit

public class CpfUtil {
    
    //MARK: - Mask
    
    static public func unmask(_ str: String?) -> String {
        guard var str = str else {
            return ""
        }
        
        str = str.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "-", with: "")
        return str
    }
    
    static public func mask(_ str: String?) -> String {
        guard let str = str, str.isNotEmpty else {
            return ""
        }
        
        let unmasked = unmask(str)
        if unmasked.length != 11 {
            return ""
        }
        
        let masked = unmasked.substring(from: 0, to: 2) + "." + unmasked.substring(from: 3, to: 5) + "." + unmasked.substring(from: 6, to: 8) + "-" + unmasked.substring(from: 9, to: 10)
        return masked
    }
    
    static public func isMasked(_ possibleCpf: String?) -> Bool {
        guard let string = possibleCpf, string.length == 14 else {
            return false
        }
        
        for offset in stride(from: 3, through: 9, by: 4) {
            let index = string.index(string.startIndex, offsetBy: offset)
            let wrongCharacter = offset == 9 ? string[index] != "-" : string[index] != "."
            if wrongCharacter {
                return false
            }
        }
        
        return true
    }
    
    //MARK: - Validation
    
    static public func isValid(_ str: String?) -> Bool {
        guard let string = str, string.isNotEmpty else {
            return false
        }
        
        let cpf = unmask(string)
        if cpf.length != 11 || !cpf.isNumber {
            return false
        }
        
        var primeiroDigitoVerificador = ""
        var segundoDigitoVerificador = ""
        
        var j = 0
        var sum = 0
        var result = 0
        
        for weight in stride(from: 10, to: 1, by: -1) {
            let substring = cpf[cpf.index(cpf.startIndex, offsetBy: j)]
            let segment = String(substring).utf8
            
            sum += weight * NumberUtil.toInteger("\(segment)")
            j += 1
        }
        
        result = 11 - (sum % 11)
        if result == 10 || result == 11 {
            primeiroDigitoVerificador = "0"
        } else {
            if let scalar = UnicodeScalar(result + 48) {
                primeiroDigitoVerificador.unicodeScalars.append(scalar)
            } else {
                return false
            }
        }
        
        let penultimoDigito = cpf.substring(with: cpf.index(cpf.endIndex, offsetBy: -2) ..< cpf.index(cpf.endIndex, offsetBy: -1))
        if !primeiroDigitoVerificador.equalsIgnoreCase(penultimoDigito) {
            return false
        }
        
        j = 0
        sum = 0
        
        for weight in stride(from: 11, to: 1, by: -1) {
            let substring = cpf[cpf.index(cpf.startIndex, offsetBy: j)]
            let segment = String(substring).utf8
            
            sum += weight * NumberUtil.toInteger("\(segment)")
            j += 1
        }
        
        result = 11 - (sum % 11)
        if result == 10 || result == 11 {
            segundoDigitoVerificador = "0"
        } else {
            if let scalar = UnicodeScalar(result + 48) {
                segundoDigitoVerificador.unicodeScalars.append(scalar)
            } else {
                return false
            }
        }
        
        let ultimoDigito = cpf.substring(with: cpf.index(cpf.endIndex, offsetBy: -1) ..< cpf.endIndex)
        if !segundoDigitoVerificador.equalsIgnoreCase(ultimoDigito) {
            return false
        }
        
        return true
    }
}
