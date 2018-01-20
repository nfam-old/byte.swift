extension Int {
    public init?<S>(_ bytes: S, radix: Int = 10)
    where S: Sequence, S.Iterator.Element == Byte {
        guard 2 <= radix && radix <= 36 else {
            return nil
        }
        var result: Int = 0
        var signed = false
        var digited = false
        var positive = true
        for byte in bytes {
            if !signed { // sign or first-digit
                if byte == .plus {
                    signed = true
                } else if byte == .hyphen {
                    signed = true
                    positive = false
                } else if let d: Int = byte.digit(radix: radix) {
                    signed = true
                    digited = true
                    result = d
                } else {
                    return nil
                }
            } else if let d: Int = byte.digit(radix: radix) {
                digited = true
                let (result1, overflow1) = result.multipliedReportingOverflow(by: radix)
                let (result2, overflow2) = positive
                    ? result1.addingReportingOverflow(d)
                    : result1.subtractingReportingOverflow(d)
                guard !overflow1 && !overflow2 else {
                    return nil
                }
                result = result2
            } else {
                return nil
            }
        }
        guard signed && digited else {
            return nil
        }
        self = result
    }
}
