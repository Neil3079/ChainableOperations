# ChainableOperations

The aim of this repo is to discover a way effectively pass objects between operations and define operation workflows which will throw and compiler error when a a programmer attempts to connect incompatible operations. The idea is to combine ChainableOperations into structures called OperationChains. OperationChains can then be added to an Operation Queue.

Currently the repo takes advantage of the Operations "framework" defined in the [WWDC 2015 AdvancedNSOperations sample code](https://developer.apple.com/sample-code/wwdc/2015/)

## Usage

### Declare ChainableOperations

Define your subclasses of ChainableOperation declaring their Input and Output Type like so.

```swift
class TestChainableOperationOne: ChainableOperation<Void, String> {
  override func main(input: Void) {
    finish(.Success("test"))
  }
}

class TestChainableOperationTwo: ChainableOperation<String, Void> {
  override func main(input: String) {
    print(input)
    finish(.Success())
  }
}

```

### Combine ChainableOperations to create an OperationChain

When creating an operation chain the first operation must have an input type of void, this behavior is enforced by the compiler. The Input Type of the second ChainableOperation must equal the OutputType of the first ChainableOperation, again this behavior is enforced by the compiler.

```swift
  let operationChain = TestChainableOperationOne()
                     ==> TestChainableOperationTwo()
```

### Extend the chain

We can now extend the chain by adding more ChainableOperation's to the OperationChain.

```swift
  let extendedChain = operationChain ==> TestChainableOperationThree()
```

Or we can actually chain these operators and get rid of the need for multiple constants.

```swift
  let operationChain = TestChainableOperationOne()
                     ==> TestChainableOperationTwo()
                     ==> TestChainableOperationThree()
```

## TODO
* Add tests
* Chainable Block operations
* Investigate multiple Input/Output ChainableOperations (Though this is currently achieved using tuples)
* Investigate ChainableOperation that takes input from multiple ChainableOperations
