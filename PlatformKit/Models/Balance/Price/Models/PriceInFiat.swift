//
//  PriceInFiat.swift
//  Blockchain
//
//  Created by Chris Arriola on 10/22/18.
//  Copyright © 2018 Blockchain Luxembourg S.A. All rights reserved.
//

import NetworkKit

/// Model for a quoted price by the Service-Price endpoint in fiat for a single asset type.
public struct PriceInFiat: Codable, Equatable {
    public let timestamp: Date?
    public let price: Decimal
    public let volume24h: Decimal?
    
    public static func ==(lhs: PriceInFiat, rhs: PriceInFiat) -> Bool {
        return lhs.timestamp == rhs.timestamp &&
        lhs.price == rhs.price &&
        lhs.volume24h == rhs.volume24h
    }
    
    public init(timestamp: Date?, price: Decimal, volume24h: Decimal?) {
        self.timestamp = timestamp
        self.price = price
        self.volume24h = volume24h
    }
    
    public init(response: PriceInFiatResponse) throws {
        self.init(
            timestamp: response.timestamp,
            price: response.price,
            volume24h: response.volume24h
        )
    }
}

public struct PriceInFiatValue: Codable, Equatable {
    fileprivate let base: PriceInFiat
    fileprivate let currencyCode: String
    
    public static func ==(lhs: PriceInFiatValue, rhs: PriceInFiatValue) -> Bool {
        return lhs.base == rhs.base &&
        lhs.currencyCode == rhs.currencyCode
    }
}

extension PriceInFiatValue {
    public var priceInFiat: FiatValue {
        return FiatValue.create(amount: base.price, currencyCode: currencyCode)
    }
}

extension PriceInFiat {
    public static let empty: PriceInFiat = PriceInFiat(timestamp: nil, price: 0, volume24h: nil)

    public func toPriceInFiatValue(currencyCode: String) -> PriceInFiatValue {
        return PriceInFiatValue(base: self, currencyCode: currencyCode)
    }
}
