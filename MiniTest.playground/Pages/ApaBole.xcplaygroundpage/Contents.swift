import UIKit

for i in 1...100 {
    if i % 3 == 0 && i % 5 == 0 {
        print("ApaBole")
    } else if i % 3 == 0 {
        print("Apa")
    } else if i % 5 == 0 {
        print("Bole")
    } else {
        print(i)
    }
}

