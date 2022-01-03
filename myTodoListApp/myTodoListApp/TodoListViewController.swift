//
//  ViewController.swift
//  myTodoListApp
//
//  Created by sae hun chung on 2021/12/27.
//

import UIKit

class TodoListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var isTodayButton: UIButton!
    @IBOutlet weak var addButton: UIButton!

    // [x] TODO: TodoViewModel 만들기
    let todoListViewModel = TodoViewModel()
    
    override func viewDidLoad() { // 메모리에 올라감.
        super.viewDidLoad()
        
        // TODO: 키보드 디텍션
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), // 이게 호출됨
                                               name: UIResponder.keyboardWillShowNotification, // 키보드가 나타날 때
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView),
                                               name: UIResponder.keyboardWillHideNotification, // 키보드가 사라질 때
                                               object: nil)
        
        // TODO: 데이터 불러오기
        todoListViewModel.loadTasks()
        
//        let todo = TodoManager.shared.createTodo(detail: "👍🥴코로나 난리", isToday: true)
//        Storage.saveTodo(todo, fileName: "test.json")
    } // end viewDidLoad()
    
    override func viewDidAppear(_ animated: Bool) { //
        super.viewDidAppear(animated)
        
//        let todo = Storage.restoreTodo("test.json")
//        print("---> restore from disk: \(todo)")
    } // end viewDidAppear()

    @IBAction func isTodayButtonTapped(_ sender: Any) {
        // TODO: Today button toggle
        isTodayButton.isSelected = !isTodayButton.isSelected
    }
    
    @IBAction func addTaskButtonTapped(_ sender: Any) {
        // TODO: Add Todo task
        // add task to view model
        // and tableview reload or update
        
        guard let detail = inputTextField.text, detail.isEmpty == false else { return }
        let todo = TodoManager.shared.createTodo(detail: detail, isToday: isTodayButton.isSelected)
        
        todoListViewModel.addTodo(todo)
        collectionView.reloadData()
        
        inputTextField.text = "" // inputTextField refresh
        isTodayButton.isSelected = false
    }

    // TODO: BG tap 할 경우, keyboard 내려가도록 설정
    @IBAction func tapBG(_ sender: Any) {
        inputTextField.resignFirstResponder() // 사용자에게 우선순위를 내림 -> 이제 기능 사용 X
    }
}

extension TodoListViewController {
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        // TODO: 키보드 높이에 따른 인풋뷰 위치 변경
        // 키보드의 frame 정보를 요청할 수 있다.
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] // 키보드가 다 움직이고 난 뒤의 keyboard Frame 정보
                                   as? NSValue)?.cgRectValue else { return }
        if noti.name == UIResponder.keyboardWillShowNotification { // 키보드가 올라왔을 때
            // 수정해야할 높이 정보
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom // iPhone X 이후 model부터 notch를 포함한 safeArea가 있다.
            inputViewBottom.constant = adjustmentHeight
        } else {
            inputViewBottom.constant = 0
        }
    }
} // end

extension TodoListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // TODO: 세션 몇 개?
        return todoListViewModel.numOfSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: 섹션 별 item 몇 개?
        if section == 0 {
            return todoListViewModel.todayTodos.count
        } else {
            return todoListViewModel.upcomingTodos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: 커스텀 셀
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoListCell", for: indexPath) as? TodoListCell else {
            return UICollectionViewCell()
        }
//        return cell
        var todo: Todo
        if indexPath.section == 0 {
            todo = todoListViewModel.todayTodos[indexPath.item]
        } else {
            todo = todoListViewModel.upcomingTodos[indexPath.item]
        }
        cell.updateUI(todo: todo)
        // [x]custom cell
        // [x]TODO: todo를 이용해서 updateUI
        // [x]TODO: doneButtonHandler 작성
        // [x]TODO: deleteButtonHandler 작성
        
        // check button 눌럿을때 -> isDone
        cell.doneButtonTapHandler = { isDone in
            todo.isDone = isDone
            self.todoListViewModel.updateTodo(todo)
            self.collectionView.reloadData()
        }
        
        cell.deleteButtonTapHandler = {
            self.todoListViewModel.deleteTodo(todo)
            self.collectionView.reloadData()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TodoListHeaderView", for: indexPath) as? TodoListHeaderView else {
                return UICollectionReusableView()
            }
            
            guard let section = TodoViewModel.Section(rawValue: indexPath.section) else {
                return UICollectionReusableView()
            }
            
            header.sectionTitleLabel.text = section.title
            return header
        default:
            return UICollectionReusableView()
        }
    }}

extension TodoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width
        let height: CGFloat = 50
        return CGSize(width: width, height: height)
    }
}

class TodoListCell: UICollectionViewCell {
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var strikeThroughView: UIView!
    
    @IBOutlet weak var strikeThroughwidth: NSLayoutConstraint!
    
    var doneButtonTapHandler: ((Bool) -> Void)?
    var deleteButtonTapHandler: (() -> Void)?
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        reset()
//    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    func updateUI(todo: Todo){
        // TODO: cell update 하기
        checkButton.isSelected = todo.isDone
        descriptionLabel.text = todo.detail
        descriptionLabel.alpha = todo.isDone ? 0.2 : 1 // isDone = True 이면 투명도 0.2
        deleteButton.isHidden = todo.isDone == false
        showStrikeThrough(todo.isDone)
    }
    
    func showStrikeThrough(_ show: Bool) {
        if show {
            strikeThroughwidth.constant = descriptionLabel.bounds.width
        } else {
            strikeThroughwidth.constant = 0
        }
    }
    
    func reset() {
        // TODO: Logic 구현
        // 초기 화면에 나타낼 reset
        // storyboard 에서 깨어났을때, 한번 reset 후 화면에 display 된다.
        descriptionLabel.alpha = 1 // 투명도 0
        deleteButton.isHidden = true // 삭제버튼 숨기기
        showStrikeThrough(false) // strikeThrough 안보이게 시작
    }
    
    @IBAction func  checkButtonTapped(_ sender: Any) {
        // TODO: checkButton 처리
        // view update closure
        checkButton.isSelected = !checkButton.isSelected
        let isDone = checkButton.isSelected
        showStrikeThrough(isDone)
        descriptionLabel.alpha = isDone ? 0.2 : 1
        deleteButton.isHidden = !isDone
        
        // data update closure
        doneButtonTapHandler?(isDone) // handler
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        // TODO: deleteButton 처리
        // view에서는 삭제하지 않고, 원래 data에서 삭제하고 view를 reset 하는 방식으로 한다.
        // 여기는 view 객체이기 때문에, 여기서 처리해줄 것은 딱히 없다.
        deleteButtonTapHandler?()
    }

}

class TodoListHeaderView: UICollectionReusableView {
    @IBOutlet weak var sectionTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
