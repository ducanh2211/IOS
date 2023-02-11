//
//  OrderListViewModel.swift
//  CoffeeApp
//
//  Created by Đức Anh Trần on 29/12/2022.
//

import Foundation

struct OrderListViewModel {
    var orders: [OrderViewModel]
    var numberOfRow: Int {
        return orders.count
    }
    func orderAtRow(at index: Int) -> OrderViewModel {
        return orders[index]
    }
    
    init() {
        self.orders = [OrderViewModel]()
    }
}

struct OrderViewModel {
    var order: Order
    var name: String {
        return order.name
    }
    var email: String {
        return order.email
    }

    var type: String {
        return order.type.rawValue.uppercased()
    }
    var size: String {
        return order.size.rawValue.uppercased()
    }
}
