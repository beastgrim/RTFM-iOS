// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: other_models.proto
//
// For information on using the generated types, please see the documenation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that your are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct ClientValidationList {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var clients: Dictionary<Int64,Bool> = [:]

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Payment {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var clientID: Int64 = 0

  var transactionID: Int64 = 0

  var transportID: Int64 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct CompletedPayment {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var price: String = String()

  var type: TransportType = .bus

  var title: String = String()

  var date: Int32 = 0

  var id: Int64 = 0

  var status: Status = .success

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct RecentPaymentsRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var clientID: Int64 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct RecentPaymentsResponce {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var payments: [CompletedPayment] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct UserInfoRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var clientID: Int64 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct UserInfoResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var status: UserInfoResponse.PayStatus = .available

  var balance: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  enum PayStatus: SwiftProtobuf.Enum {
    typealias RawValue = Int
    case available // = 0
    case blocked // = 1
    case UNRECOGNIZED(Int)

    init() {
      self = .available
    }

    init?(rawValue: Int) {
      switch rawValue {
      case 0: self = .available
      case 1: self = .blocked
      default: self = .UNRECOGNIZED(rawValue)
      }
    }

    var rawValue: Int {
      switch self {
      case .available: return 0
      case .blocked: return 1
      case .UNRECOGNIZED(let i): return i
      }
    }

  }

  init() {}
}

#if swift(>=4.2)

extension UserInfoResponse.PayStatus: CaseIterable {
  // The compiler won't synthesize support with the UNRECOGNIZED case.
  static var allCases: [UserInfoResponse.PayStatus] = [
    .available,
    .blocked,
  ]
}

#endif  // swift(>=4.2)

struct SessionOpenRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var driverID: Int32 = 0

  var transportID: Int32 = 0

  var traceID: Int32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct SessionOpenResponce {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var sessionID: Int32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct SessionCloseRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var sessionID: Int32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct GetPriceRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var transportID: Int32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct GetPriceResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var price: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct TransactionSyncRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var payments: [Payment] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct RefilRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var clientID: Int32 = 0

  var value: Int32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension ClientValidationList: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "ClientValidationList"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "Clients"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeMapField(fieldType: SwiftProtobuf._ProtobufMap<SwiftProtobuf.ProtobufInt64,SwiftProtobuf.ProtobufBool>.self, value: &self.clients)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.clients.isEmpty {
      try visitor.visitMapField(fieldType: SwiftProtobuf._ProtobufMap<SwiftProtobuf.ProtobufInt64,SwiftProtobuf.ProtobufBool>.self, value: self.clients, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: ClientValidationList, rhs: ClientValidationList) -> Bool {
    if lhs.clients != rhs.clients {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Payment: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "Payment"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "ClientID"),
    2: .same(proto: "TransactionID"),
    3: .same(proto: "TransportID"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularInt64Field(value: &self.clientID)
      case 2: try decoder.decodeSingularInt64Field(value: &self.transactionID)
      case 3: try decoder.decodeSingularInt64Field(value: &self.transportID)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.clientID != 0 {
      try visitor.visitSingularInt64Field(value: self.clientID, fieldNumber: 1)
    }
    if self.transactionID != 0 {
      try visitor.visitSingularInt64Field(value: self.transactionID, fieldNumber: 2)
    }
    if self.transportID != 0 {
      try visitor.visitSingularInt64Field(value: self.transportID, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Payment, rhs: Payment) -> Bool {
    if lhs.clientID != rhs.clientID {return false}
    if lhs.transactionID != rhs.transactionID {return false}
    if lhs.transportID != rhs.transportID {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension CompletedPayment: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "CompletedPayment"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "price"),
    2: .same(proto: "type"),
    3: .same(proto: "title"),
    4: .same(proto: "date"),
    5: .same(proto: "id"),
    6: .same(proto: "status"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularStringField(value: &self.price)
      case 2: try decoder.decodeSingularEnumField(value: &self.type)
      case 3: try decoder.decodeSingularStringField(value: &self.title)
      case 4: try decoder.decodeSingularInt32Field(value: &self.date)
      case 5: try decoder.decodeSingularInt64Field(value: &self.id)
      case 6: try decoder.decodeSingularEnumField(value: &self.status)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.price.isEmpty {
      try visitor.visitSingularStringField(value: self.price, fieldNumber: 1)
    }
    if self.type != .bus {
      try visitor.visitSingularEnumField(value: self.type, fieldNumber: 2)
    }
    if !self.title.isEmpty {
      try visitor.visitSingularStringField(value: self.title, fieldNumber: 3)
    }
    if self.date != 0 {
      try visitor.visitSingularInt32Field(value: self.date, fieldNumber: 4)
    }
    if self.id != 0 {
      try visitor.visitSingularInt64Field(value: self.id, fieldNumber: 5)
    }
    if self.status != .success {
      try visitor.visitSingularEnumField(value: self.status, fieldNumber: 6)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: CompletedPayment, rhs: CompletedPayment) -> Bool {
    if lhs.price != rhs.price {return false}
    if lhs.type != rhs.type {return false}
    if lhs.title != rhs.title {return false}
    if lhs.date != rhs.date {return false}
    if lhs.id != rhs.id {return false}
    if lhs.status != rhs.status {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension RecentPaymentsRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "RecentPaymentsRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "client_id"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularInt64Field(value: &self.clientID)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.clientID != 0 {
      try visitor.visitSingularInt64Field(value: self.clientID, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: RecentPaymentsRequest, rhs: RecentPaymentsRequest) -> Bool {
    if lhs.clientID != rhs.clientID {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension RecentPaymentsResponce: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "RecentPaymentsResponce"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "Payments"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeRepeatedMessageField(value: &self.payments)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.payments.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.payments, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: RecentPaymentsResponce, rhs: RecentPaymentsResponce) -> Bool {
    if lhs.payments != rhs.payments {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension UserInfoRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "UserInfoRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "client_id"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularInt64Field(value: &self.clientID)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.clientID != 0 {
      try visitor.visitSingularInt64Field(value: self.clientID, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: UserInfoRequest, rhs: UserInfoRequest) -> Bool {
    if lhs.clientID != rhs.clientID {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension UserInfoResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "UserInfoResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "status"),
    2: .same(proto: "balance"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularEnumField(value: &self.status)
      case 2: try decoder.decodeSingularStringField(value: &self.balance)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.status != .available {
      try visitor.visitSingularEnumField(value: self.status, fieldNumber: 1)
    }
    if !self.balance.isEmpty {
      try visitor.visitSingularStringField(value: self.balance, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: UserInfoResponse, rhs: UserInfoResponse) -> Bool {
    if lhs.status != rhs.status {return false}
    if lhs.balance != rhs.balance {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension UserInfoResponse.PayStatus: SwiftProtobuf._ProtoNameProviding {
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "Available"),
    1: .same(proto: "Blocked"),
  ]
}

extension SessionOpenRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "SessionOpenRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "driver_id"),
    2: .standard(proto: "transport_id"),
    3: .standard(proto: "trace_id"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularInt32Field(value: &self.driverID)
      case 2: try decoder.decodeSingularInt32Field(value: &self.transportID)
      case 3: try decoder.decodeSingularInt32Field(value: &self.traceID)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.driverID != 0 {
      try visitor.visitSingularInt32Field(value: self.driverID, fieldNumber: 1)
    }
    if self.transportID != 0 {
      try visitor.visitSingularInt32Field(value: self.transportID, fieldNumber: 2)
    }
    if self.traceID != 0 {
      try visitor.visitSingularInt32Field(value: self.traceID, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SessionOpenRequest, rhs: SessionOpenRequest) -> Bool {
    if lhs.driverID != rhs.driverID {return false}
    if lhs.transportID != rhs.transportID {return false}
    if lhs.traceID != rhs.traceID {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SessionOpenResponce: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "SessionOpenResponce"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "session_id"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularInt32Field(value: &self.sessionID)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.sessionID != 0 {
      try visitor.visitSingularInt32Field(value: self.sessionID, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SessionOpenResponce, rhs: SessionOpenResponce) -> Bool {
    if lhs.sessionID != rhs.sessionID {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SessionCloseRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "SessionCloseRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "session_id"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularInt32Field(value: &self.sessionID)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.sessionID != 0 {
      try visitor.visitSingularInt32Field(value: self.sessionID, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SessionCloseRequest, rhs: SessionCloseRequest) -> Bool {
    if lhs.sessionID != rhs.sessionID {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension GetPriceRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "GetPriceRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "transport_id"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularInt32Field(value: &self.transportID)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.transportID != 0 {
      try visitor.visitSingularInt32Field(value: self.transportID, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: GetPriceRequest, rhs: GetPriceRequest) -> Bool {
    if lhs.transportID != rhs.transportID {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension GetPriceResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "GetPriceResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "Price"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularStringField(value: &self.price)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.price.isEmpty {
      try visitor.visitSingularStringField(value: self.price, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: GetPriceResponse, rhs: GetPriceResponse) -> Bool {
    if lhs.price != rhs.price {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension TransactionSyncRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "TransactionSyncRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "Payments"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeRepeatedMessageField(value: &self.payments)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.payments.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.payments, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: TransactionSyncRequest, rhs: TransactionSyncRequest) -> Bool {
    if lhs.payments != rhs.payments {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension RefilRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "RefilRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "client_id"),
    2: .same(proto: "value"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularInt32Field(value: &self.clientID)
      case 2: try decoder.decodeSingularInt32Field(value: &self.value)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.clientID != 0 {
      try visitor.visitSingularInt32Field(value: self.clientID, fieldNumber: 1)
    }
    if self.value != 0 {
      try visitor.visitSingularInt32Field(value: self.value, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: RefilRequest, rhs: RefilRequest) -> Bool {
    if lhs.clientID != rhs.clientID {return false}
    if lhs.value != rhs.value {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
