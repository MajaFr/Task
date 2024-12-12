//
//  FirebaseDatabase.swift
//
//
//  Created by Maja on 12/12/2024.
//

// This class is supposed to pretend that after sending a payment request, we will get a new model with information about this transaction.

class FirebaseDatabase {
    private var transaction: [FirebaseTransaction] = FirebaseTransaction.sampleData
    private var submitedNewPayment = false
    
    func firebaseFetchTransation(with id: String, completion: (FirebaseTransaction?) -> ()) {
        fetchData {
            if submitedNewPayment {
                self.transaction += FirebaseTransaction(
                    id: id,
                    amount: Double.random(in: 1...1000),
                    date: Date())
                submitedNewPayment = false
            }
            // The API returns all transactions but I only take one with a given ID
            completion(transaction.filter { $0.id == id }.first)
        }
    }
    
    // I start the payment and after it is finished I return her ID
    func submitPayment(comletion: (String) -> ()) {
        submitedNewPayment = true
        fetchData {
            comletion(UUID().uuidString)
        }
    }
    
    private func fetchData(completion: () -> ()) {
        // I pretend to download something for example
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            completion()
        }
    }
}
