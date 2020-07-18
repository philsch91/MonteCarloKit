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
    
    func testNodeCopy() {
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
        
        NSLog("node: %@ %@", node.nid, node)
        
        print("---")
        
        let copyNode = node.copy() as! MCTreeNode
        NSLog("node copy: %@ %@", copyNode.nid, copyNode)
        
        //1
        print(node === copyNode)
        //2
        let cnode1 = node.nodes[0] as! MCTreeNode
        let cnode2 = copyNode.nodes[0] as! MCTreeNode
        print(cnode1 === cnode2)
        //3
        let ccnode1 = cnode1.nodes[0] as! MCTreeNode
        let ccnode2 = cnode2.nodes[0] as! MCTreeNode
        print(ccnode1 === ccnode2)
        
        XCTAssertEqual(node.isEqual(copyNode) && cnode1.isEqual(cnode2) && ccnode1.isEqual(ccnode2), true, "node copies are equal")
    }
    
    func testNodeCopy2() {
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
        
        NSLog("node: %@ %@", node.nid, node)
        
        let nodeCopy = node.copy() as! MCTreeNode
        NSLog("node copy: %@ %@", nodeCopy.nid, nodeCopy)
        
        let childNode = node.nodes[0] as! MCTreeNode
        let childChildNode = childNode.nodes[0] as! MCTreeNode
        print("childChildNode.nid: \(childChildNode.nid)")
        
        let childNodeCopy = nodeCopy.nodes[0] as! MCTreeNode
        let childChildNodeCopy = childNodeCopy.nodes[0] as! MCTreeNode
        print("childChildNodeCopy.nid: \(childChildNodeCopy.nid)")
        
        XCTAssertEqual(childNode.nid == childNodeCopy.nid && childChildNode.nid == childChildNodeCopy.nid, true, "node ids are equal")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
