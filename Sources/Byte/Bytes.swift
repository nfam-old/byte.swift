/// A byte array or collection of raw data.
public typealias Bytes = [Byte]

/// A sliced collection of raw data
public typealias BytesSlice = ArraySlice<Byte>

/// Used for objects that can be represented as Bytes.
public protocol BytesRepresentable {
    func makeBytes() throws -> Bytes
}

/// Used for objects that can be initialized with Bytes.
public protocol BytesInitializable {
    init(bytes: Bytes) throws
}

/// Used for objects that can be initialized with, and represented by, Bytes.
public protocol BytesConvertible: BytesRepresentable, BytesInitializable { }

extension BytesInitializable {
    public init(bytes: BytesRepresentable) throws {
        let bytes = try bytes.makeBytes()
        try self.init(bytes: bytes)
    }
}

/// Append the right-hand byte to the end of the bytes array
public func += (lhs: inout Bytes, rhs: Byte) {
    lhs.append(rhs)
}

/// Append the contents of the byteslice to the end of the bytes array
public func += (lhs: inout Bytes, rhs: BytesSlice) {
    lhs += Array(rhs)
}

extension Array where Element == Byte {
    public mutating func append(unicode scalar: UInt) {
        if scalar <= 0x7F {
            append(Byte(scalar))
        } else if scalar <= 0x7FF {
            append(Byte(0xC0 | (scalar >> 6)))
            append(Byte(0x80 | (scalar & 0x3F)))
        } else if scalar <= 0xFFFF {
            append(Byte(0xE0 | (scalar >> 12)))
            append(Byte(0x80 | ((scalar >> 6) & 0x3F)))
            append(Byte(0x80 | (scalar & 0x3F)))
        } else if scalar <= 0x1FFFFF {
            append(Byte(0xF0 | (scalar >> 18)))
            append(Byte(0x80 | ((scalar >> 12) & 0x3F)))
            append(Byte(0x80 | ((scalar >> 6) & 0x3F)))
            append(Byte(0x80 | (scalar & 0x3F)))
        } else if scalar <= 0x3FFFFFF {
            append(Byte(0xF8 | (scalar >> 24)))
            append(Byte(0x80 | (scalar >> 18)))
            append(Byte(0x80 | ((scalar >> 12) & 0x3F)))
            append(Byte(0x80 | ((scalar >> 6) & 0x3F)))
            append(Byte(0x80 | (scalar & 0x3F)))
        } else if scalar <= 0x7FFFFFFF {
            append(Byte(0xFC | (scalar >> 30)))
            append(Byte(0x80 | ((scalar >> 24) & 0x3F)))
            append(Byte(0x80 | ((scalar >> 18) & 0x3F)))
            append(Byte(0x80 | ((scalar >> 12) & 0x3F)))
            append(Byte(0x80 | ((scalar >> 6) & 0x3F)))
            append(Byte(0x80 | (scalar & 0x3F)))
        }
        // don't output invalid UTF-8 byte sequence to a stream
    }
}
