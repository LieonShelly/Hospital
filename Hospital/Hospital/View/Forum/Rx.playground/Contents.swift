//: Playground - noun: a place where people can play

import UIKit
import RxSwift
import RxSwift

var str = "Hello, playground"
let sequence = 0 ..< 3
var iterator = sequence.makeIterator()
while let n = iterator.next() {
    print(n)
}
let one = 1
let two = 2
let three = 3
Observable.of(one, two, three)
            .subscribe { (event) in
                if let element = event.element {
                    }
                }

/// Empty: they’re handy when you want to return an observable that immediately terminates, or intentionally has zero values.
Observable<Void>.empty()
                .subscribe(onNext: { element in
                    print(element)
                }, onCompleted: { 
                    print("complicated")
                })

/// Never: It can be use to represent an infinite duration. Add this example to the playground
Observable<Any>.never()
                .subscribe(onNext: { (element) in
                    print(element)
                }, onCompleted: { 
                    print("Complicated")
                })

/// Range
Observable<Int>.range(start: 1, count: 10)
                .subscribe(onNext: { (i) in
                    let n = Double(i)
                    let fibonacci = Int(((pow(1.61803, n) - pow(0.61803, n)) /
                        2.23606).rounded())
                    print(fibonacci)
                }, onCompleted: {
                    print("Complicated")
                })

/// Disposing and terminating
let observable = Observable.of("A", "B", "C")
observable.subscribe { (event) in
                        print(event)
                    }
            .dispose()
let disposeBag = DisposeBag()
observable.subscribe {
            print($0)
    }
    .addDisposableTo(disposeBag)

/// Create
enum MyError: Error {
    case anError
}

Observable<String>.create { observer in
    observer.onNext("1")
    observer.onError(MyError.anError)
    observer.onCompleted()
    observer.onNext("?")
    return Disposables.create()
}
    .subscribe(onNext: { print($0)},
               onError: { print($0)},
               onCompleted: { print("Completed")},
               onDisposed: { print("Disposed")})
    .addDisposableTo(disposeBag)


// Subject
func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, event.element ?? event.error ?? event)
}
BehaviorSubject(value: "Initial value").subscribe(onNext: { print($0)}) .addDisposableTo(disposeBag)
BehaviorSubject(value: "Initial value").onNext("X")

let subject = ReplaySubject<String>.create(bufferSize: 2)
subject.onNext("1")
subject.onNext("2")
subject.onNext("3")
subject.subscribe(onNext: { (value) in
            print(value)
        })
        .addDisposableTo(disposeBag)

subject.subscribe(onNext: { (value) in
                print(value)
    })
    .addDisposableTo(disposeBag)

subject.onNext("4")
subject.subscribe(onNext: { (value) in
    print(value)
})
    .addDisposableTo(disposeBag)

subject.dispose()

/// Variables

var variable = Variable("Initial Value")
variable.value = "new initial value"
variable.asObservable()
    .subscribe {
        print(label: "1)", event: $0)
}.addDisposableTo(disposeBag)
variable.value = "1"
variable.asObservable().subscribe {
    print(label: "1)", event: $0)
}.addDisposableTo(disposeBag)
variable.value = "2"

/// filter

Observable.of(1, 2, 3, 4, 5, 6, 7)
    .filter { integer -> Bool in
    integer % 2 == 0
}.subscribe(onNext: {
    print($0)
})
.disposed(by: disposeBag)

/// skip
Observable.of("A", "B", "C", "D", "E", "F", "G")
.skip(3)
    .subscribe(onNext: {
        print($0)
    })
.disposed(by: disposeBag)

/// skpipWhile
Observable.of(2, 2, 3, 4, 4)
.skipWhile { (integer) -> Bool in
    integer % 2 == 0
}
.subscribe(onNext: {
    print($0)
})
.disposed(by: disposeBag)

/// skipUntil
let pubilishSubject = PublishSubject<String>()
let trigger = PublishSubject<String>()
pubilishSubject.skipUntil(trigger)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
pubilishSubject.onNext("A")
pubilishSubject.onNext("B")
trigger.onNext("X")
subject.onNext("C")

/// take
Observable.of(1, 2, 3, 4, 5, 6, 7)
.take(3)
.subscribe(onNext: {
    print($0) // ===> 1, 2, 3, 4
})
.disposed(by: disposeBag)

/// takeWhile
Observable.of(2, 2, 4, 4, 6, 6)
.takeWhileWithIndex { (integer, index) -> Bool in
   return integer % 2 == 0 && index < 3
}.subscribe(onNext: {
     print($0) // ===> 2, 2, 4
}).disposed(by: disposeBag)

/// takeUntil
pubilishSubject.takeUntil(trigger)
    .subscribe(onNext: {
        print($0) // ===> A, B
    }).disposed(by: disposeBag)
pubilishSubject.onNext("A")
pubilishSubject.onNext("B")
trigger.onNext("X")
pubilishSubject.onNext("C")

/// distinctUntilChanged
Observable.of("A", "A", "B", "B", "A")
.distinctUntilChanged()
    .subscribe(onNext: {
        print($0) // ===> A, B, A
    }).disposed(by: disposeBag)

/// startWith
let number = Observable.of(2, 3, 4)
number.startWith(1)
    .subscribe(onNext: { (value) in
    print(value)
}).disposed(by: disposeBag)

/// concat
let first = Observable.of(1, 2, 3)
let second = Observable.of(4, 5, 6)
Observable.concat([first, second])
    .subscribe(onNext: { (value) in
    print(value)
})
    .disposed(by: disposeBag)

first.concat(second)
    .subscribe(onNext: { (value) in
    print(value)
})
.disposed(by: disposeBag)

/// 
let left = PublishSubject<String>()
let right = PublishSubject<String>()
let source = Observable.of(left.asObservable(), right.asObservable())
source.merge()
    .subscribe(onNext: { (value) in
        print(value)
})
    .disposed(by: disposeBag)
var leftValue = ["Berlin", "Munich", "Franfurt"]
var rightValue = ["asf", "asfd", "sdg"]
repeat {
    if arc4random_uniform(2) == 0 {
        if !leftValue.isEmpty {
            left.onNext("left: " + leftValue.removeFirst())
        } else if rightValue.isEmpty {
            right.onNext("Right:" + rightValue.removeFirst())
        }
    }
} while !leftValue.isEmpty || !rightValue.isEmpty

/// combining
Observable.combineLatest(left, right) { (lastLeft, lastRight) -> String in
    return "\(lastLeft)" + "\(lastRight)"
    
}.subscribe(onNext: { (value) in
    print(value)
}).disposed(by: disposeBag)

let choice: Observable<DateFormatter.Style> = Observable.of(.short, .long)
let dates = Observable.of(Date())
Observable.combineLatest(choice, dates) { (format, when) -> String in
    let formatter = DateFormatter()
    formatter.dateStyle = format
    return formatter.string(from: when)
}.subscribe(onNext: { (value) in
    print(value)
}).disposed(by: disposeBag)

/// zip

enum Weather {
    case cloudy
    case sunny
}

let leftWeather: Observable<Weather> = Observable.of(.sunny, .cloudy, .cloudy, .sunny)
let rightWeather: Observable<String> = Observable.of("Lisbon", "Copenhagen", "London", "aassd", "Vienna")
Observable.zip(leftWeather, rightWeather) { (weather, city) -> String in
    return "It's\(weather) in \(city)"
}.subscribe(onNext: { (value) in
    print(value)
}).disposed(by: disposeBag)
