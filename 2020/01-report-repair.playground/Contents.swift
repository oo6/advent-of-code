import UIKit

let input = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "txt")!)

let list = input.split(separator: "\n").map { Int($0)! }.sorted()

func partOne() -> Int {
  for i in 0..<list.count {
    for j in i..<list.count {
      let s = list[i] + list[j]

      if s == 2020 {
        return list[i] * list[j]
      }
      if s > 2020 {
        break
      }
    }
  }

  return 0
}

func partTwo() -> Int {
  for i in 0..<list.count {
    for j in i..<list.count {
      let s = list[i] + list[j]

      if s > 2020 {
        break
      }

      for k in j..<list.count {
        if s + list[k] == 2020 {
          return list[i] * list[j] * list[k]
        }
        if s + list[k] > 2020 {
          break
        }
      }
    }
  }

  return 0
}

print(partOne())
print(partTwo())
