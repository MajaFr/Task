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
    var lastTransactionSubject: PassthroughSubject<MFTransaction, Error> { get set }
    func submitPayment()
}

public class MFPaymentSDK: MFPaymentSDKProtocol {
    public var lastTransactionSubject = PassthroughSubject<MFTransaction, Error>()
    
    public static let shared: MFPaymentSDKProtocol = MFPaymentSDK()
    private init() {
        bind()
    }
    
    private let networkService: FirebaseDatabase = FirebaseDatabase()
    private var cancellables = Set<AnyCancellable>()
    
    func bind() {
        NotificationCenter.default
            .publisher(for: .lastTransactionUpdate)
            .debounce(for: .seconds(1), scheduler: RunLoop.current)
            .compactMap { $0.userInfo?["transactionID"] as? String }
            .sink { [weak self] id in
                self?.networkService.firebaseFetchTransation(with: id) { transaction in
                    if let transaction {
                        self?.lastTransactionSubject.send(transaction.toMFModel)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    public func submitPayment() {
        networkService.submitPayment { id in
            //After a successful or unsuccessful payment we get notifications, it could also be from firebase, let's say it works like silentPush, or websocket
            NotificationCenter.default.post(
                name: .lastTransactionUpdate,
                object: nil,
                userInfo: ["transactionID": id]
            )
        }
    }
}
