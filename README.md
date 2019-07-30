# MonteCarloKit

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Reinforcement Learning with Monte-Carlo methods

## Usage

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

### Classes

- MCState
- MCTreeNode
- MCTS

### Protocols (Interfaces)

- MCStateDelegate

### License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
