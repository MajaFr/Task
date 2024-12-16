//
//  FirebaseTransation.swift
//
//
//  Created by Maja on 12/12/2024.
//

public struct FirebaseTransaction: Codable {
    public let id: String
    public let amount: Double
    public let date: Date
    
    public var toMFModel: MFTransaction {
        MFTransaction(id: id, amount: amount, date: date)
    }
}

public extension FirebaseTransaction {
    static let sampleData: [FirebaseTransaction] = [
        FirebaseTransaction(
            id: "778ce974-fd91-4458-8b70-1e950b1e3127",
            amount: 199.00,
            date: Date(timeIntervalSince1970: 1731010971)),
        FirebaseTransaction(
            id: "851226f3-8f28-43d5-a20e-13a805074fab",
            amount: 119.00,
            date: Date(timeIntervalSince1970: 1734810971)),
        FirebaseTransaction(
            id: "cb06485b-aee6-4311-bc45-c4af6673e4d7",
            amount: 349.00,
            date: Date(timeIntervalSince1970: 1734060971)),
        FirebaseTransaction(
            id: "307a095b-8eef-4766-ab68-03b53e15a514",
            amount: 9.49,
            date: Date(timeIntervalSince1970: 1694010971)),
    ]
}

