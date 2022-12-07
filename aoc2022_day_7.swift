import Foundation

let input = """
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
"""

let inputStrings = input.split(separator: "\n", omittingEmptySubsequences: true).map({ String($0) })

// helpers

class Directory {
    var name: String
    var childDirectories: [Directory] = []
    var childFiles: [String: Int] = [:]
    var parent: Directory?

    init(name: String, parent: Directory? = nil) {
        self.name = name
        self.parent = parent
    }

    func sizeOfChild() -> Int {
        let sizeOfFiles = childFiles.compactMap({ $0.value }).reduce(0, { $0 + $1 })
        let sizeOfDirs = childDirectories.compactMap({ $0.sizeOfChild() }).reduce(0, { $0 + $1 })
        return sizeOfFiles + sizeOfDirs
    }


    func fillSizes(includingOuter: Bool) {
        if includingOuter || name != "/" {
            sizes.append(sizeOfChild())
        }

        for child in childDirectories {
            child.fillSizes(includingOuter: includingOuter)
        }
    }

    func goToDirectory(name: String) {
        for child in childDirectories {
            if child.name == name {
                currentDirectory = child
                return
            }
            child.goToDirectory(name: name)
        }
    }
}

var currentDirectory: Directory?
var head: Directory?

var ls = false

for inputString in inputStrings {
    if inputString.hasPrefix("$ ") {
        ls = false

        // cd
        if inputString.hasPrefix("$ cd ") {
            if inputString == "$ cd /" {
                if head == nil {
                    head = Directory(name: "/")
                }
                currentDirectory = head
            } else if inputString == "$ cd .." {
                currentDirectory = currentDirectory?.parent
            } else {
                let name = String(inputString.suffix(inputString.count - 5))
                currentDirectory?.goToDirectory(name: name)
            }
        }

        // ls
        else if inputString.hasPrefix("$ ls") {
            ls = true
        }
    }

    // parse files and dirs
    else if ls {
        // size
        if inputString.hasPrefix("dir") {
            let name = String(inputString.suffix(inputString.count - 4))
            currentDirectory?.childDirectories.append(Directory(name: name, parent: currentDirectory))

            // file
        } else {
            let split = inputString.split(separator: " ")
            let size = Int(String(split[0])) ?? 0
            let name = String(split[1])
            currentDirectory?.childFiles[name] = size
        }
    }

}

// part one

var sizes: [Int] = []
var sum = 0
var max = 100000

head?.fillSizes(includingOuter: false)
print(sizes.reduce(0, { $0 + ($1 <= max ? $1 : 0) }))

// part two

var total = 70000000
var free = 30000000

sizes = []
head?.fillSizes(includingOuter: true)

var outer = sizes.max() ?? 0
var toClear = free - (total - outer)

print(sizes.filter({ $0 > toClear }).min() ?? 0 )
