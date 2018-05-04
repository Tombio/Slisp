
public enum SymbolicExcepression {
    case Atom(String)
    case List([SymbolicExcepression])
}

extension SymbolicExcepression: Equatable {
    public static func ==(lhs: SymbolicExcepression, rhs: SymbolicExcepression) -> Bool {
        switch(lhs, rhs) {
        case let(.Atom(l), Atom(r)):
            return l == r
        case let(.List(l), .List(r)):
            guard l.count == r.count else {
                return false
            }
            for(index, element) in l.enumerated() {
                if element != r[index] {
                    return false
                }
            }
            return true
        default:
            return false
        }
    }
}

extension SymbolicExcepression: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .Atom(value):
            return "\(value)"
        case let .List(expressions):
            var ret =  "("
            expressions.forEach { ret += "\($0) " }
            ret += ")"
            return ret
        }
    }
}

extension SymbolicExcepression {
    
    public static func read(_ expression: String) -> SymbolicExcepression {
        
        enum Token {
            case open
            case close
            case textBlock(String)
        }
        
        func tokenize(_ expression: String) -> [Token] {
            var res = [Token]()
            var tmpText = ""
            
            for character in expression {
                switch character {
                case "(":
                    if tmpText != "" {
                        res.append(.textBlock(tmpText))
                        tmpText = ""
                    }
                    res.append(.open)
                case ")":
                    if tmpText != "" {
                        res.append(.textBlock(tmpText))
                        tmpText = ""
                    }
                    res.append(.close)
                case " ":
                    if tmpText != "" {
                        res.append(.textBlock(tmpText))
                        tmpText = ""
                    }
                default:
                    tmpText.append(character)
                }
            }
            return res
        }
        
        func appendTo(list: SymbolicExcepression?, node: SymbolicExcepression) -> SymbolicExcepression {
            var list = list
            if list != nil, case var .List(elements) = list! {
                elements.append(node)
                list = .List(elements)
            }
            else {
                list = node
            }
            return list!
        }
        
        func parse(_ tokens: [Token], node: SymbolicExcepression? = nil) -> (remaining: [Token], subexpression: SymbolicExcepression?) {
            var tokens = tokens
            var node = node
            
            var i = 0
            repeat {
                let t = tokens[i]
                switch t {
                case .open:
                    let (tr, n) = parse(Array(tokens[i+1..<tokens.count]), node: .List([]))
                    assert(n != nil)
                    (tokens, i) = (tr, 0)
                    node = appendTo(list: node, node: n!)
                    if tokens.count != 0 {
                        continue
                    }
                    else {
                        break
                    }
                case .close:
                    return (Array(tokens[i+1..<tokens.count]), node)
                case let .textBlock(value):
                    node = appendTo(list: node, node: .Atom(value))
                }
                i += 1
            } while (tokens.count > 0)
            
            return ([], node)
        }
        
        let tokens = tokenize(expression)
        let res = parse(tokens)
        return res.subexpression ?? .List([])
    }
}
