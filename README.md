# MonteCarloKit

A Monte-Carlo tree search framework written in Objective-C.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Usage

### Swift

```swift
//initialize root node
var rootNode = MCTreeNode()

//initialize stop flag and pointer to it
var treeStopFlag: ObjCBool = false
var pTreeStopFlag: UnsafeMutablePointer<ObjcBool> = UnsafeMutablePointer<ObjcBool>(&treeStopFlag)

//initialize Monte-Carlo tree search
var treeSearch = MCTS(rootNode, simulationCount: UInt(Int.max))
treeSearch.pStopFlag = pTreeStopFlag
treeSearch.stateDelegate = self

//start tree search in the background
treeStopFlag = false
DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
  treeSearch.main()
}

//stop tree search
treeStopFlag = true

//implement MCStateDelegate
func getStateUpdates(for node: MCTreeNode, depth: UInt) -> [MCTreeNode] {
  //return an array of MCTreeNodes for the expansion and simulation phase of the Monte-Carlo tree search
}

func evaluate(_ currentNode: MCTreeNode, with simNode: MCTreeNode) -> Double {
  //return the numerator value for the given start node and backpropagation with the help of the simulated (or terminal) node from the simulation phase
}

```

## Build and Compile

Hint: clang -Wall -framework Foundation -isysroot `xcrun --show-sdk-path` MCTS.m

```console
#### Point sysdir to iOS SDK
export SDKROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk

#### create object files for x86_64 architecture for use in the simulator
clang -c MCState.m -o MCState-x86_64.o -target x86_64-apple-ios-simulator
clang -c MCTreeNode.m -o MCTreeNode-x86_64.o -target x86_64-apple-ios-simulator
clang -c MCTS.c -m MCTS-x86_64.o -target x86_64-apple-ios-simulator

#### create object files for arm64 architecture for real devices with bitcode enabled
clang -c MCState.m -o MCState-arm64.o -target arm64-apple-ios -fembed-bitcode
clang -c MCTreeNode.m -o MCTreeNode-arm64.o -target arm64-apple-ios -fembed-bitcode
clang -c MCTS.m -o MCTS-arm64.o -target arm64-apple-ios -fembed-bitcode

#### create universal object files
lipo -create MCState-x86_64.o MCState-arm64.o -output MCState.o
lipo -create MCTreeNode-x86_64.o MCTreeNode-arm64.o -output MCTreeNode.o
lipo -create MCTS-x86_64.o MCTS-arm64.o -output MCTS.o

#### create a universal static library (MonteCarloKit.a) from the object files
libtool -static MCState.o MCTreeNode.o MCTS.o -o MonteCarloKit.a

#### create a universal dynamic library:
libtool -dynamic MCState.o MCTreeNode.o MCTS.o -o MonteCarloKit.dylib
```

### Classes

- MCState
- MCTreeNode
- MCTS

### Protocols (Interfaces)

- MCStateDelegate

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
