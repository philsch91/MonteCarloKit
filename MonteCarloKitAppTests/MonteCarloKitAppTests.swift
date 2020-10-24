//
//  MonteCarloKitAppTests.swift
//  MonteCarloKitAppTests
//
//  Created by Philipp Schunker on 18.07.20.
//  Copyright © 2020 Philipp Schunker. All rights reserved.
//

import XCTest
@testable import MonteCarloKit

class MonteCarloKitAppTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNodeId() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let node = MCTreeNode()
        node.nid = "0"
        
        XCTAssertEqual(node.nid, "0", "node id must be 0")
    }
    
    func testChildNodes() {
        let node = MCTreeNode()
        node.nid = "0"
        
        let node1 = MCTreeNode()
        node1.nid = "1"
        
        let node2 = MCTreeNode()
        node2.nid = "2"
        
        node1.addNode(node2)
        
        let node3 = MCTreeNode()
        node3.nid = "3"
        
        node.addNode(node1)
        node.addNode(node3)
        
        NSLog("%@ %@", node.nid, node)
        
        /*
        numberWords.forEach { word in
            print(word)
        }*/
        
        guard let nodes = node.nodes as? [MCTreeNode] else {
            print("failure")
            return
        }
        
        XCTAssertEqual(node.nodes.count, 2, "childnode must be 2")
    }
    
    func testChildNodes2() {
        let node = self.createTree()
        NSLog("%@ %@", node.nid, node)
        
        guard let nodes = node.nodes as? [MCTreeNode] else {
            NSLog("failure")
            return
        }
        
        var childNodeCount = 0
        
        for inode in nodes {
            print("\(inode.nid) \(inode)")
            
            if (inode.nodes.count > 0) {
                guard let cnodes = inode.nodes as? [MCTreeNode] else {
                    return
                }
                
                for icnode in cnodes {
                    //print(icnode.nid)
                    //print(icnode)
                    NSLog("%@ %@", icnode.nid, icnode)
                    childNodeCount += 1
                }
            }
        }
        
        XCTAssertEqual(childNodeCount, 1, "count of child's nodes child nodes must be 1")
    }
    
    func testChildNodesRecursive() {
        let node = self.createTree()
        let count = self.countNodes(node)
        print("testChildNodesRecursive count: \(count)")

        XCTAssertEqual(count, 4, "count of nodes must be 4")
    }

    func testChildNodesRecursive2() {
        let node = self.createTree()
        let childNode3 = node.nodes[1] as! MCTreeNode
        
        let childNode4 = MCTreeNode()
        childNode4.nid = "4"
        
        childNode3.addNode(childNode4)
        NSLog("childNode4.parent: %@", childNode4.parent ?? "nil")
        
        let count = self.countNodes(node)
        print("testChildNodesRecursive2 count: \(count)")

        XCTAssertEqual(count, 5, "count of nodes must be 5")
    }

    func testNodeCopy() {
        let node = self.createTree()
        NSLog("node: %@ %@", node.nid, node)
        
        print("---")
        
        let nodeCopy = node.copy() as! MCTreeNode
        NSLog("node copy: %@ %@", nodeCopy.nid, nodeCopy)
        
        //1
        print(node === nodeCopy)
        //2
        let childNode1 = node.nodes[0] as! MCTreeNode
        let childNode1Copy = nodeCopy.nodes[0] as! MCTreeNode
        print(childNode1 === childNode1Copy)
        //3
        let childNode2 = childNode1.nodes[0] as! MCTreeNode
        let childNode2Copy = childNode1Copy.nodes[0] as! MCTreeNode
        print(childNode2 === childNode2Copy)

        XCTAssertEqual(node.isEqual(nodeCopy) && childNode1.isEqual(childNode1Copy) && childNode2.isEqual(childNode2Copy), true, "node copies are equal")
    }

    func testNodeCopyIds() {
        let node = self.createTree()
        NSLog("node: %@ %@", node.nid, node)

        let nodeCopy = node.copy() as! MCTreeNode
        NSLog("node copy: %@ %@", nodeCopy.nid, nodeCopy)

        let childNode = node.nodes[0] as! MCTreeNode
        let childNode2 = childNode.nodes[0] as! MCTreeNode
        print("childNode2.nid: \(childNode2.nid)")

        let childNodeCopy = nodeCopy.nodes[0] as! MCTreeNode
        let childNode2Copy = childNodeCopy.nodes[0] as! MCTreeNode
        print("childNode2Copy.nid: \(childNode2Copy.nid)")

        XCTAssertEqual(childNode.nid == childNodeCopy.nid && childNode2.nid == childNode2Copy.nid, true, "node ids are equal")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func createTree() -> MCTreeNode {
        let node = MCTreeNode()
        node.nid = "0"
        
        let node1 = MCTreeNode()
        node1.nid = "1"
        
        let node2 = MCTreeNode()
        node2.nid = "2"
        
        node1.addNode(node2)
        
        let node3 = MCTreeNode()
        node3.nid = "3"
        
        node.addNode(node1)
        node.addNode(node3)
        
        return node
    }

    func countNodes(_ node: MCTreeNode) -> Int {
        var count = 1

        guard let nodes = node.nodes as? [MCTreeNode] else {
            return count
        }

        for node in nodes {
            count += countNodes(node)
            //count += countNodes(node as! MCTreeNode)
        }

        return count
    }

}
