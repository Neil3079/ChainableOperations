# ChainableOperations

The aim of this repo is to discover a way effectively pass objects between operations and define operation workflows which will throw and compiler error when a a programmer attempts to connect incompatible operations.

##OperationChain

A object describing a workflow created from operations. All initialisers are private and these objects must be created using factory methods. Where possible we will use sensible operators to call these static functions to increase readability of the code. 

Most of the work enforcing types is done in th initialiser of this class

```swift
class OperationChain<Input, OutputType> {
  let operations: [ChainableOperationType]
  
  private init(operations: [ChainableOperationType], lastOperation: ChainableOperation<Input,OutputType> ) {
    var allOperations = operations
    guard let previousLastOperation = allOperations.last else {
      allOperations.append(lastOperation)
      self.operations = allOperations
      return
    }
    if let previousLastOperation  = previousLastOperation as? NSOperation {
      lastOperation.addDependency(previousLastOperation)
    }
    previousLastOperation.nextOperation = lastOperation
    allOperations.append(lastOperation)
    self.operations = allOperations
  }
  
  private init(operation: NoInputChainableOperation<OutputType> ) {
    self.operations = [operation]
  }
  
  static func join<X,Y,Z>(previousChain: OperationChain<Z,X>, newOperation: ChainableOperation<X,Y>) -> OperationChain<X,Y> {
    return OperationChain<X,Y>(operations: previousChain.operations, lastOperation: newOperation)
  }
  
  static func create<Y>(operation: NoInputChainableOperation<Y>) -> OperationChain<Void,Y> {
    return OperationChain<Void, Y>(operation: operation)
  }
}
```

##InitialChainableOperation
The first chainable operation that must be added to an operation chain (this is enforced by the lack of OperationChain initialisers and factory methods). This operation has no input but does have an output. This output will be passed to the next operation in the queue.

##ChainableOperation
A chainable operation is a generic subclass of `Operation` as defined in the AppleOperations framework created for the WWDC 2015 talk `AdvancedNSOperations`. The genrics define the input and output type allowing communication between operations. The grunt of the work is done in the new finish method which expects a result enum.

```swift
final func finish(result: Result<Output>) {
    switch result {
    case .Success(let output):
      guard let nextOperation = nextOperation as? InputOperationType else {
        fatalError()
      }
      nextOperation.setInput(output)
      finishWithError(nil)
    case .Failure(let error):
      finishWithError(error)
    }
  }
```
