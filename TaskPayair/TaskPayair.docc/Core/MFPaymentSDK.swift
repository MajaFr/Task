//
//  MFPaymentSDKProtocol.swift
//
//
//  Created by Maja on 12/12/2024.
//

import Foundation
import Combine

// I am providing a protocol that will contain all the necessary information for the application that means just start the payment "submitPayment" and watching for changes for "lastTransationSubject".
// Whether it was successful or not can't be added in the Transaction mosel extension.

public protocol MFPaymentSDKProtocol: AnyObject {
    public var lastTransactionSubject: PassthroughSubject<MFTransaction, Error> { get set }
    public func submitPayment()
}

public class MFPaymentSDK: MFPaymentSDKProtocol {
    public let lastTransactionSubject = PassthroughSubject<MFTransaction, Error>()
    
    public static let shared: MFPaymentSDKProtocol = MFPaymentSDK()
    private init() {}
    
    private let networkService: FirebaseDatabase = FirebaseDatabase()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        bind()
    }
    
    func bind() {
        NotificationCenter.default
            .publisher(for: .lastTransactionUpdated)
            .sink { [weak self] _ in
                self?.networkService.firebaseFetchTransaction(with: id) { transaction in
                    if let transaction {
                        self?.lastTransactionSubject.send(transaction)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    public func submitPayment() {
        networkService.submitPayment { [weak self] id in
            //After a successful or unsuccessful payment we get notifications, it could also be from firebase, let's say it works like silentPush, or websocket
            NotificationCenter.default.post(
                name: .lastTransactionUpdated,
                object: nil
            )
        }
    }
}
