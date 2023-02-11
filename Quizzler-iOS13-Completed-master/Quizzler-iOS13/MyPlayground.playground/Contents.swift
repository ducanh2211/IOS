import UIKit
import Foundation

// Post a notification in the child view controller
class ChildViewController: UIViewController {
    func sendDataBackToParent() {
        let data = "Data to be sent back"
        NotificationCenter.default.post(name: NSNotification.Name("DidSendData"), object: data)
    }
}

// Observe the notification in the parent view controller
class ParentViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveData(_:)), name: NSNotification.Name("DidSendData"), object: nil)
    }
    
    @objc func didReceiveData(_ notification: Notification) {
        if let data = notification.object as? String {
            // Use the data received from the child view controller
            print("Received data: \(data)")
        }
    }
}


//class ViewController: UIViewController {
//  lazy var collectionView: UICollectionView = {
//    let layout = UICollectionViewFlowLayout()
//    layout.scrollDirection = .horizontal
//    layout.minimumLineSpacing = 0
//    layout.minimumInteritemSpacing = 0
//
//    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//    collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "Cell")
//    collectionView.dataSource = self
//    collectionView.delegate = self
//    collectionView.backgroundColor = .white
//    collectionView.showsHorizontalScrollIndicator = false
//
//    return collectionView
//  }()
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    view.addSubview(collectionView)
//    collectionView.translatesAutoresizingMaskIntoConstraints = false
//    NSLayoutConstraint.activate([
//      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
//      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//      collectionView.heightAnchor.constraint(equalToConstant: 200)
//    ])
//  }
//}
//
//extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    return 10
//  }
//
//  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCell
//    cell.backgroundColor = .red
//    return cell
//  }
//
//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
//  }
//}
//
//class CustomCell: UICollectionViewCell {
//  override init(frame: CGRect) {
//    super.init(frame: frame)
//    setupViews()
//  }
//
//  required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//
//  func setupViews() {
//    backgroundColor = .white
//  }
//}


//enum Err: Error {
//    case ErrorDauBuoi
//}
//
//guard let url = URL(string: "https://google.com") else {throw Err.ErrorDauBuoi}
//func makeRequets(url: URL , completion: @escaping(Data)-> Void) {
//    URLSession.shared.dataTask(with: url) { data, responce, err in
//        if let err = err {
//            print(err.localizedDescription)
//        } else {
//            print("HELLO >>>>>>>>>")
//            guard let data = data else {
//                print("CAC")
//                return
//            }
//            completion(data)
//        }
//        print("DOne 3")
//    }.resume()
//    print("DONE 2")
//}
//
//makeRequets(url: url) { data in
//    print("Vippro >>>>>>")
//    print("data.count ??????????????????????????")
//}
//
//for i in 1..<30000 {
//    print(i)
//}


//struct Human {
//    var name: String
//    var age: Int
//    var sex: String
//    var address: String
//
//    var dictionary: [String: Any] {
//        [
//            "name": name,
//            "age": "\(age)",
//            "sex": sex,
//            "address": address
//        ]
//    }
//
//    init?(_ dictionary: [String: Any]) {
//        guard let name = dictionary["name"] as? String,
//              let age = dictionary["age"] as? String,
//              let sex = dictionary["sex"] as? String,
//              let address = dictionary["address"] as? String
//        else {
//            return nil
//        }
//
//        self.name = name
//        self.age = Int(age)!
//        self.sex = sex
//        self.address = address
//    }
//}
//
//let me = Human([
//    "name": "duc anh",
//    "age": "22",
//    "sex": "male",
//    "address": "hanoi"
//])
//
//print(type(of: me!.dictionary))
//print(me!)

//let time = Date().timeIntervalSince1970
//print(time)
//
//let str1 = 1675595753.827765
//let str2 = 1675595753
//
//let t1 = Date(timeIntervalSince1970: TimeInterval(str1))
//let t2 = Date(timeIntervalSince1970: TimeInterval(str2))
//

//print(formatter.string(from: t1))
//print(formatter.string(from: t2))

//let formatter = DateFormatter()
//formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
//
//for i in 1...5 {
//    let time = Date().timeIntervalSince1970
//    let t = Date(timeIntervalSince1970: TimeInterval(time))
//    print("\(i): \(time)")
//    print("\(i): \(formatter.string(from: t))")
//}
