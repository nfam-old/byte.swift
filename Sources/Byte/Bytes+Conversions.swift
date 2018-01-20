extension Sequence where Iterator.Element == Byte {
    /// Converts a slice of bytes to string.
    public func makeString() -> String {
        let array = Array(self) + [0]
        return array.withUnsafeBytes { bp in
            let pointer = bp.baseAddress!.assumingMemoryBound(to: CChar.self)
            var string = ""
            var index = 0
            for i in 0 ..< array.count where array[i] == 0 {
                if i > index {
                    if let str = String(validatingUTF8: pointer.advanced(by: index)) {
                        if string == "" {
                            string = str
                        } else {
                            string.append(str)
                        }
                    } else {
                        return nil
                    }
                }
                if i < array.count - 1 {
                    string.append("\u{0}")
                }
                index = i + 1
            }
            return string
        } ?? ""
    }

    /// Transforms anything between Byte.A ... Byte.Z into the range Byte.a ... Byte.z
    public var lowercased: Bytes {
        var data = Bytes()

        for byte in self {
            if (.A ... .Z).contains(byte) {
                data.append(byte + (.a - .A))
            } else {
                data.append(byte)
            }
        }

        return data
    }

    /// Transforms anything between Byte.a ... Byte.z into the range Byte.A ... Byte.Z
    public var uppercased: Bytes {
        var bytes = Bytes()

        for byte in self {
            if (.a ... .z).contains(byte) {
                bytes.append(byte - (.a - .A))
            } else {
                bytes.append(byte)
            }
        }

        return bytes
    }
}
