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

    
    @IBOutlet weak var timerLabel: UILabel! // 타이머 라벨
    
    @IBOutlet weak var progressView: UIProgressView! // 프로그레스바
    
    @IBOutlet weak var datePicker: UIDatePicker! // 데이트피커
    
    @IBOutlet weak var cancelButton: UIButton! // 취소버튼
    
    @IBOutlet weak var toggleButton: UIButton! // 시작, 일시정지버튼
    
    // 타이머의 시간을 초 단위로 저장하는 프로퍼티
    var duration = 60 // 타이머 데이트피커가 기본적으로 1분으로 초기화 되어있기 때문에 60으로 설정
    
    // 타이머의 상태를 가지고 있는 프로퍼티
    var timerStatus: TimerStatus = .end
    
    //디스패치타이머 프로퍼티
    var timer: DispatchSourceTimer?
    
    //현재 카운트다운되고 있는 시간을 초 로저장하는 프로퍼티
    var currentSeconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureToggleButton()
    }
    
    //MARK: -  타이머 설정 및 시작
    func startTimer() {
        if self.timer == nil {
            // 타이머 객체생성
            //작업할 쓰레드 큐 설정; 타이머 돌리면서 메인에서 ui작업을 하기때문에 메인으로 설정해주어야함.
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            
            //어떤 주기로 타이머를 실행할것인지 설정 .now() 바로 시작; .now() + 3 3초후 시작
            self.timer?.schedule(deadline: .now(), repeating: 1) // 1초마다 반복
            
            //타이머가 동작할때마다 호출되는 핸들러함수
            self.timer?.setEventHandler(handler: {
                [weak self] in
                self?.currentSeconds -= 1 // 즉 1초마다 1씩 감소
                debugPrint(self?.currentSeconds)
                
                if self?.currentSeconds ?? 0 <= 0 {
                    self?.stopTimer() //타이머가 종료
                }
            })
            self.timer?.resume() // 일시정지후 다시 시작 버튼을 눌렀을때 재개하도록 즉, nil이 아닐경우
        }
    }
    
    //MARK: - 타이머 정지
    func stopTimer() {
        if self.timerStatus == .pause {
            self.timer?.resume() // 재개 상태를 만들어야 타이머 해제해도 에러발생안함.
        }
        self.timerStatus = .end // 타이머 상태 종료 설정.
        self.cancelButton.isEnabled = false // 취소버튼 비활성
        self.setTimerInfoViewVisible(isHidden: true) // 타이머 라벨, 프로그레스바 히든
        self.datePicker.isHidden = false // 데이트피커 나타남
        self.toggleButton.isSelected = false // 시작 버튼으로 표시되게함.
        self.timer?.cancel() // 타이머 정지
        self.timer = nil // 타이머를 메모리에서 해제; 해제하지않으면 화면을 벗어나도 동작할 우려가 있음.
    }

    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        switch self.timerStatus {
        case .start, .pause: //타이머 상태가 시작, 일시정지 상태라면
            self.stopTimer() // 타이머 종료
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
            self.currentSeconds = self.duration // 현재 시간 설정
            self.timerStatus = .start
            self.setTimerInfoViewVisible(isHidden: false) // 타이머, 프로그레스바 표시
            self.datePicker.isHidden = true // 데이트피커 사라짐.
            self.toggleButton.isSelected = true // 시작 버튼 일시정지로 변경
            self.cancelButton.isEnabled = true // 취소버튼 활성화
            self.startTimer()
            
        case .start:
            self.timerStatus = .pause
            self.toggleButton.isSelected = false // 일시정지에서 시작 버튼으로 변경
            self.timer?.suspend() // 타이머 일시정지; 타이머가 처리해야할 일이 남은 상태, 이때 타이머에 nil을 넣어 해제하면 런타임 에러발생
            
        case .pause:
            self.timerStatus = .start
            self.toggleButton.isSelected = true // 시작에서 다시 일시정지 버튼으로 변경
            self.timer?.resume() // 타이머 다시동작
        default:
            break
        }
    }

}

