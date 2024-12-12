//
//  MFPayment.swift
//  
//
//  Created by Maja on 12/12/2024.
//

public struct MFTransaction: Codable {
    public let id: String
    public let amount: Double
    public let data: Data
}

public extension MFTransaction: Equatable {
    public static func == (lhs: MFTransaction, rhs: MFTransaction) -> Bool {
        lhs.id = rhs.id
    }
}
