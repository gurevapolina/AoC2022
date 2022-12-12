import Foundation

let input = """
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
"""

let inputStrings = input.split(separator: "\n", omittingEmptySubsequences: true).map({ String($0) })

// helpers

let matrix = inputStrings.map({ $0.map({ $0 }) })
let height = matrix.count
let width = matrix.first?.count ?? 0

func shouldGo(from: Node, to: Character) -> Bool {
    if to == "E" && from.name != "z" {
        return false
    }
    if from.name == "S" && to == "a" {
        return true
    }
    if from.name == "z" && to == "E" {
        return true
    }
    let diff = Int(to.asciiValue ?? 0) - Int(from.name.asciiValue ?? 0)
    if diff <= 1 {
        return true
    }

    return false
}

func shouldGo(from: Node, to: (Int, Int)) -> Bool {
    return shouldGo(from: from, to: matrix[to.0][to.1])
}

class Node {
    var coordinates: (Int, Int) = (0, 0)
    var path: String = ""

    var name: Character {
        return matrix[coordinates.0][coordinates.1]
    }

    init(coordinates: (Int, Int), path: String) {
        self.coordinates = coordinates
        self.path = path
    }
}

var nodes: [Node] = []

for i in 0..<height {
    for j in 0..<width {
        let node = Node(coordinates: (i, j), path: "")
        nodes.append(node)
    }
}

func path(from: Node) -> String {
    let to = nodes.first(where: { $0.name == "E" })!

    var shouldVisit: [Node] = [from]
    var visited = Set<[Int]>()

    while shouldVisit.isEmpty == false {
        let node = shouldVisit.removeFirst()

        if node.coordinates == to.coordinates {
            return node.path
        }
        if visited.contains([node.coordinates.0, node.coordinates.1]) {
            continue
        }
        visited.insert([node.coordinates.0, node.coordinates.1])

        if node.coordinates.0 > 0 && shouldGo(from: node, to: (node.coordinates.0 - 1, node.coordinates.1)) {
            shouldVisit.append(Node(coordinates: (node.coordinates.0 - 1, node.coordinates.1),
                                    path: node.path + String(matrix[node.coordinates.0 - 1][node.coordinates.1])))
        }

        if node.coordinates.0 < height - 1 && shouldGo(from: node, to: (node.coordinates.0 + 1, node.coordinates.1)) {
            shouldVisit.append(Node(coordinates: (node.coordinates.0 + 1, node.coordinates.1),
                                    path: node.path + String(matrix[node.coordinates.0 + 1][node.coordinates.1])))
        }

        if node.coordinates.1 > 0 && shouldGo(from: node, to: (node.coordinates.0, node.coordinates.1 - 1)) {
            shouldVisit.append(Node(coordinates: (node.coordinates.0, node.coordinates.1 - 1),
                                    path: node.path + String(matrix[node.coordinates.0][node.coordinates.1 - 1])))
        }

        if node.coordinates.1 < width - 1 && shouldGo(from: node, to: (node.coordinates.0, node.coordinates.1 + 1)) {
            shouldVisit.append(Node(coordinates: (node.coordinates.0, node.coordinates.1 + 1),
                                    path: node.path + String(matrix[node.coordinates.0][node.coordinates.1 + 1])))
        }
    }
    return ""
}

// part one

let start = nodes.first(where: { $0.name == "S" })!
var shortestPath = path(from: start)
print(shortestPath.count)

// part two

shortestPath.removeAll(where: { $0 == "a" })
print(shortestPath.count - 1)
