//
//  Executable.swift
//  astra
//
//  Created by Miten Gajjar on 17/03/25.
//
import Foundation

protocol Executable: Identifiable<String> {
    var id: String { get }
    var name: String { get }
    var icon: String { get }
}
