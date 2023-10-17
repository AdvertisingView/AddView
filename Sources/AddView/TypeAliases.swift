//
//  Created by Developer on 07.12.2022.
//
import Foundation

//MARK: - CLOUSURES
public typealias Closure<T>        = ((T) -> Void)
public typealias ClosureEmpty      = (() -> Void)
public typealias ClosureTwo<T, G>  = ((T, G) -> Void)
public typealias ClosureAny        = ((Any?) -> Void)
