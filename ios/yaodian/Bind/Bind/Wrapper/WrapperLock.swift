import Foundation

private protocol Lock {
	func lock()
	func unlock()
}

extension Lock {
	/// Executes a closure returning a value while acquiring the lock.
	///
	/// - Parameter closure: The closure to run.
	///
	/// - Returns:           The value the closure generated.
	func around<T>(_ closure: () -> T) -> T {
		lock(); defer { unlock() }
		return closure()
	}

	/// Execute a closure while acquiring the lock.
	///
	/// - Parameter closure: The closure to run.
	func around(_ closure: () -> Void) {
		lock(); defer { unlock() }
		closure()
	}
}

/// An `os_unfair_lock` wrapper.
final class BLock: Lock {

	private let nslock: NSLock

	init() {
        nslock = NSLock()
	}

	fileprivate func lock() {
        nslock.lock()
	}

	fileprivate func unlock() {
        nslock.unlock()
    }
}

@propertyWrapper
public struct WrapperLock<T> {

	private let lock = BLock()

    private var value: T

	public init(_ value: T) {
		self.value = value
	}

	/// The contained value. Unsafe for anything more than direct read or write.
	public var wrappedValue: T {
		get { lock.around { value } }
		set { lock.around { value = newValue } }
	}

	public init(wrappedValue: T) {
		value = wrappedValue
	}
}

