//
//  ViewController.swift
//  PomodoroTimerApp
//
//  Created by Whyeon on 2022/04/07.
//

import UIKit

enum TimerStatus {
    case start
    case pause
    case end
}

class ViewController: UIViewController {

    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var toggleButton: UIButton!
    
    // 타이머의 시간을 초 단위로 저장하는 프로퍼티
    var duration = 60 // 타이머 데이트피커가 기본적으로 1분으로 초기화 되어있기 때문에 60으로 설정
    
    // 타이머의 상태를 가지고 있는 프로퍼티
    var timerStatus: TimerStatus = .end
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureToggleButton()
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        switch self.timerStatus {
        case .start, .pause: //타이머 상태가 시작, 일시정지 상태라면
            self.timerStatus = .end // 타이머 상태 종료 설정.
            self.cancelButton.isEnabled = false // 취소버튼 비활성
            self.setTimerInfoViewVisible(isHidden: true) // 타이머 라벨, 프로그레스바 히든
            self.datePicker.isHidden = false // 데이트피커 나타남
            self.toggleButton.isSelected = false // 시작 버튼으로 표시되게함.
        default:
            break
        }
    }
    
    // 타이머 라벨과 프로그레스바 나타내거나 숨기기
    func setTimerInfoViewVisible(isHidden: Bool) {
        self.timerLabel.isHidden = isHidden
        self.progressView.isHidden = isHidden
    }
    
    func configureToggleButton() {
        self.toggleButton.setTitle("시작", for: .normal) // 평상시엔 시작 버튼
        self.toggleButton.setTitle("일시정지", for: .selected) // 버튼이 눌려진 상태면 일시정지로 바뀌고
    }
    
    @IBAction func tapToggleButton(_ sender: UIButton) {
        // countDownDuration 데이트피커에서 선택한 타이머 시간이 몇초인지 알려줌.
        self.duration = Int(self.datePicker.countDownDuration)
        debugPrint(self.duration)
        
        switch self.timerStatus {
        case .end: // 현재 상태가 end 이고 시작 버튼을 눌렀을때
            self.timerStatus = .start
            self.setTimerInfoViewVisible(isHidden: false) // 타이머, 프로그레스바 표시
            self.datePicker.isHidden = true // 데이트피커 사라짐.
            self.toggleButton.isSelected = true // 시작 버튼 일시정지로 변경
            self.cancelButton.isEnabled = true // 취소버튼 활성화
            
        case .start:
            self.timerStatus = .pause
            self.toggleButton.isSelected = false // 일시정지에서 시작 버튼으로 변경
            
        case .pause:
            self.timerStatus = .start
            self.toggleButton.isSelected = true // 시작에서 다시 일시정지 버튼으로 변경
        default:
            break
        }
    }
    

}

