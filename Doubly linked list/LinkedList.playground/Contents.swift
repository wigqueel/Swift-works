//: Playground - noun: a place where people can play

import UIKit

enum Command{
    case forward(distance: Int)
    case goRight
    case goLeft
}
func ==(lhs: Command, rhs: Command) -> Bool {
    switch (lhs, rhs) {
    case (.goRight, .goRight): return true
    case (.goLeft, .goLeft): return true
    case (.forward(let distA), .forward(let distB)): return distA == distB
    default: return false
    }
}

class LinkedList{
    private var head: LinkedListNode?
    private var tail: LinkedListNode?
    public var first: LinkedListNode? {
        return head
    }
    public var last: LinkedListNode? {
        guard var node = head else {
            return nil
        }
        
        while let next = node.next {
            node = next
        }
        return node
    }
    public func push(value: Command) {
        let newNode = LinkedListNode(value: value)
        if let lastNode = last {
            newNode.prev = lastNode
            lastNode.next = newNode
        } else {
            head = newNode
        }
        print("added ", newNode.value, "to the end")
    }
    
    public func insert(_ value: Command, at index: Int)
    {
        print("pushing \(value) at \(index) index")
        let newNode = LinkedListNode(value: value)
        if index == 0 {
            newNode.next = head
            head?.prev = newNode
            head = newNode
        } else {
            let prev = node(at: index - 1)
            let next = prev?.next
            newNode.prev = prev
            newNode.next = next
            next?.prev = newNode
            prev?.next = newNode
        }
    }
    func editEnd(what command: Command, on value: Command)
    {
        print("trying to edit ", command, "from the end on", value)
        if let node = findNodeEnd(command: command) {
            print("editing element", node.value, "from the end")
            edit(node: node, value)
        }
        else
        {
            print("there is no ", command)
        }
    }
    public func editStart(what command: Command, on value: Command)
    {
        print("trying to edit ", command, "from the start on", value)
        if let node = findNodeStart(command: command) {
            print("editing element", node.value, "from the start")
            edit(node: node, value)
        }
        else
        {
            print("there is no ", command)
        }
    }
    public func edit(on value: Command, at index : Int)
    {
        if let node = node(at: index) {
            print("editing element", node.value, "in index \(index) on \(value)")
            edit(node: node, value)
        }
        else{
            print("there is no such element")
        }
    }
    public func edit(node: LinkedListNode, _ value : Command )  {
        node.value = value
    }
    public func remove(node : LinkedListNode)
    {
        let prev = node.prev
        let next = node.next
        
        if let prev = prev {
            prev.next = next
        } else {
            head = next
        }
        next?.prev = prev
        node.prev = nil
        node.next = nil
    }
    public func findNodeStart(command: Command) -> LinkedListNode? {
        guard var node = head else {
            return nil
        }
        if (node.value == command)
        {
            return node
        }
        while let next = node.next {
            node = next
            if(next.value == command)
            {
                return next
            }
            
        }
        return nil
    }
    public func findNodeEnd(command: Command) -> LinkedListNode? {
        guard var node = last else {
            return nil
        }
        if(node.value == command)
        {
            return node
        }
        while let prev = node.prev {
            if(prev.value == command)
            {
                return prev
            }
            node = prev
        }
        return nil
    }
    public func removeStart(command: Command) {
        print("trying to delete ", command, "from the start")
        if let node = findNodeStart(command: command) {
        print("deleting element", node.value, "from the start")
        remove(node: node)
        }
        else
        {
            print("there is no ", command)
        }
        
    }
    public func removeEnd(command: Command) {
        print("trying to delete ", command, "from the end")
        if let node = findNodeEnd(command: command) {
            print("deleting element", node.value, "from the end")
            remove(node: node)
        }
        else
        {
            print("there is no ", command)
        }
    }
    public func remove( at index: Int) {
        if let node = node(at: index) {
            print("deleting element", node.value, "in index \(index)")
            remove(node: node)
        }
        else{
            print("there is no such element")
        }

    }
    public var count: Int {
        guard var node = head else {
            return 0
        }
        
        var count = 1
        while let next = node.next {
            node = next
            count += 1
        }
        return count
    }
    public subscript(index: Int) -> Command {
        if index < 0 {
            fatalError("index must be greater then 0")
        }
        if let node = self.node(at: index)
        {
            return node.value
        }
        else{
            fatalError("there is no element with index \(index)")
        }
    }
    public func node(at index: Int) -> LinkedListNode? {
        if(head == nil)
        {
            return nil
        }
        if index == 0 {
            return head
        } else {
            var node = head!.next
            for _ in 1..<index {
                node = node?.next
                if node == nil {
                    break
                }
            }
            if(node == nil)
            {
                print("index is out of bounds")
                return nil
            }
            return node
        }
    }
    
}

class LinkedListNode{
    var value: Command
    public var next: LinkedListNode?
    public var prev: LinkedListNode?
    init(value: Command) {
        self.value = value
    }
}


extension LinkedList: CustomStringConvertible {
    public var description: String {
        var text = "("
        var node = head
        while node != nil {
            text += "\(node!.value)"
            node = node!.next
            if node != nil { text += ", " }
        }
        return text + ")"
    }
}

////////////////////////////////////////////////////////
print("-------empty list-------")
let list = LinkedList()
print("empty list : ", list)
print("first element of empty list : ", list.first)
print("last element of empty list : ",list.last)
print("there is ", list.count, " elements in list")
print()
///////////////////////////////////////////////////////////
print("-------one elem list-------")
list.push(value: Command.goRight)
print(list.count, " element list : ", list)
guard let head1 = list.first?.value else{
    fatalError("head nil")
}
print("first element of \(list.count) element list : ",head1)
guard let tail1 = list.last?.value else{
    fatalError("tail nil")
}
print("last element of \(list.count) element list : ",tail1)
print("there is ", list.count, " elements in list")
print()
/////////////////////////////////////////////////////
print("-------push, count-------")
list.push(value: Command.goLeft)
list.push(value: Command.forward(distance: 100))
print("\(list.count) element list : ", list)
guard let head3 = list.first?.value else{
    fatalError("head nil")
}
print("first element of \(list.count) element list : ",head3)
guard let tail3 = list.last?.value else{
    fatalError("tail nil")
}
print("last element of \(list.count) element list : ",tail3)
print("there is ", list.count, " elements in list")
print()
//////////////////////////////////////////////////////////
print("-------removeStart-------")
list.push(value : Command.goRight)
print("before deleting element : ",list)
list.removeStart(command: Command.goRight)
print("after : ",list)
list.removeStart(command: Command.forward(distance: 10))
print("after : ",list)
list.removeStart(command: Command.forward(distance: 100))
print("after : ",list)
list.removeStart(command: Command.goLeft)
print("after : ",list)
list.removeStart(command: Command.goLeft)
print("after : ",list)
print("there is ", list.count, " elements in list")
print()
///////////////////////////////////////////////
print("-------removeEnd-------")
list.push(value: Command.goLeft)
list.push(value: Command.forward(distance: 1000))
list.push(value: Command.goRight)
print("before : ",list)
print("there is ", list.count, " elements in list")
list.removeEnd(command: Command.goRight)
print("after : ",list)
print("before : ",list)
list.removeEnd(command: Command.goRight)
print("after : ",list)
print("there is ", list.count, " elements in list")
print()
///////////////////////////////////////////////////
print("-------editStart-------")
print("before \(list)")
list.editStart(what: Command.goLeft, on: Command.forward(distance: 1))
list.editStart(what: Command.goLeft, on: Command.forward(distance: 1))
print("after \(list)")
list.removeStart(command: Command.forward(distance: 1))
list.removeStart(command: Command.forward(distance: 1000))
list.editStart(what: Command.goLeft, on: Command.forward(distance: 2))
print("after \(list)")
print()
//////////////////////////////////////////////////////////////////////////
print("-------subscript-------")
//list[0] - fatal error
list.push(value : Command.forward(distance: 1))
print("0 index - \(list[0])")
list.push(value : Command.forward(distance: 10))
list.push(value : Command.forward(distance: 100))
list.push(value : Command.goRight)
print(list)
print("1 index - \(list[1]), 2 index - \(list[2]), 3 index - \(list[3])")
//print(list[4]) - fatal error there is no elem with inex 4
//print(list[-2]) - fatal error index must be greater then 0
print()
//////////////////////////////////////////////////////////////////////////////
print("-------insert-------")
list.insert(Command.goLeft, at: 4)
print("full list - \(list), 4 index elem - \(list[4])")
list.insert(Command.goLeft, at: 10) // index is out of bound
list.insert(Command.goRight, at: 0)
print("full list - \(list), 0 index elem - \(list[0])")
list.insert(Command.forward(distance: 0), at: 3)
print("full list - \(list), 3 index elem - \(list[3])")
print()
///////////////////////////////////////////////////////////////////////////////
print("-------remove at inex, edit at index-------")
print(list)
list.edit(on: Command.goRight, at: 2)
list.remove(at: 3)
list.remove(at: 0)
list.remove(at: 0)
list.remove(at: 0)
list.remove(at: 0)
list.remove(at: 0)
list.remove(at: 0)
list.remove(at: 0)
list.remove(at: 2)
list.edit(on: Command.goRight, at: 5)
print(list)
