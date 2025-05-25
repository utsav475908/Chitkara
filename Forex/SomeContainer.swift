import Foundation

public enum SomeContainer {
    private static var dependencies: [String: Any] = [:]
    
    static func resolve<T>() -> T {
        guard let t = dependencies[String(describing: T.self)] as? T else {
            fatalError("No dependency for type \(T.self) registered.")
        }
        return t
    }
    
    static func register<T>(_ dependency: T) {
        dependencies[String(describing: T.self)] = dependency
    }
    
    public static func reset() {
        dependencies.removeAll()
    }
}

@propertyWrapper
public struct Dependency<T> {
    public var wrappedValue: T
    
    public init() {
        wrappedValue = SomeContainer.resolve()
    }
}

@propertyWrapper
public struct RegisterDependency<T> {
    public var wrappedValue: T
    
    public init(
        wrappedValue: T
    ) {
        self.wrappedValue = wrappedValue
        SomeContainer.register(wrappedValue)
    }
    
}
