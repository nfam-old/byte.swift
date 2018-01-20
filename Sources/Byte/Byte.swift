/// A single byte represented as a UInt8.
public typealias Byte = UInt8

extension Byte {
    /// Returns whether or not the given byte can be considered UTF8 whitespace.
    public var isWhitespace: Bool {
        return self == .space || self == .newLine || self == .carriageReturn || self == .horizontalTab
    }

    /// Returns whether or not the given byte is an arabic letter.
    public var isLetter: Bool {
        return (.a <= self && self <= .z) || (.A <= self && self <= .Z)
    }

    /// Returns whether or not a given byte represents a UTF8 digit 0 through 9
    public var isDigit: Bool {
        return (.zero <= self && self <= .nine)
    }

    /// Returns whether or not a given byte represents a UTF8 digit 0 through 9, or an arabic letter
    public var isAlphanumeric: Bool {
        return isLetter || isDigit
    }

    /// Returns whether a given byte can be interpreted as a hex value in UTF8, ie: 0-9, a-f, A-F.
    public var isHexDigit: Bool {
        return isDigit || (.a <= self && self <= .f) || (.A <= self && self <= .F)
    }

    public func digit<Result: BinaryInteger>(radix: Int) -> Result? {
        guard 2 <= radix && radix <= 36 else {
            return nil
        }
        let u: UInt16 = UInt16(truncatingIfNeeded: self)
        let d: UInt16
        if .zero <= self && self <= .nine {
            d = u &- UInt16(Byte.zero)
        } else if .a <= self && self <= .z {
            d = u &- UInt16(Byte.a) &+ 10
        } else if .A <= self && self <= .Z {
            d = u &- UInt16(Byte.A) &+ 10
        } else {
            return nil
        }
        guard d < radix else {
            return nil
        }
        return Result(truncatingIfNeeded: d)
    }
}
