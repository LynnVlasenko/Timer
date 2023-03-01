//
//  TimerVC.swift
//  Clock
//
//  Created by Алина Власенко on 31.01.2023.
//

import UIKit

class TimerVC: UIViewController {
    
    //MARK: - Arrays
    //створюємо константи з масивами, які передаємо за допомогою сінгелтона shared, створеного в TimerData класі
    private let allHours = TimerData.shared.hours()
    private let allMinutes = TimerData.shared.minutes()
    private let allSeconds = TimerData.shared.seconds()
    
    //private let settings = SettingsData.shared.getTimerSettings() //передаємо у константу наші дані для таблички під таймером - у SettingsData вже створений масив з даними для неї
    
    //MARK: - Timer
    private var timer = Timer() //створюємо таймер за допомогою класу Timer()
    private var countDown = 0 //задаємо початкове значення для відліку часу - лічильник
    
    //MARK: - UI objects
    
    private let timerPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 82, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private let labelHours: UILabel = {
        let label = UILabel()
        label.text = "год"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelMinutes: UILabel = {
        let label = UILabel()
        label.text = "хв"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelSeconds: UILabel = {
        let label = UILabel()
        label.text = "с"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Скинути", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .light)
        button.backgroundColor = .systemGray4
        button.setTitleColor(.gray, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        button.layer.cornerRadius = button.frame.width / 2.0
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemBackground.cgColor
        button.addTarget(self, action: #selector(resetAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let circle: UIView = {
        let circle = UIView()
        circle.backgroundColor = .systemBackground
        circle.frame = CGRect(x: 0, y: 0, width: 84, height: 84)
        circle.layer.cornerRadius = circle.frame.width / 2.0
        circle.layer.borderWidth = 2
        circle.layer.borderColor = UIColor.systemGray4.cgColor
        circle.translatesAutoresizingMaskIntoConstraints = false
        return circle
    }()
    
    private let circle2: UIView = {
        let circle = UIView()
        circle.backgroundColor = .systemBackground
        circle.frame = CGRect(x: 0, y: 0, width: 84, height: 84)
        circle.layer.cornerRadius = circle.frame.width / 2.0
        circle.layer.borderWidth = 2
        circle.layer.borderColor = UIColor(named: "SpecialGreen")?.cgColor
        circle.translatesAutoresizingMaskIntoConstraints = false
        return circle
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Пуск", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .light)
        button.backgroundColor = UIColor(named: "SpecialGreen")//.clear//UIColor(named: "SpecialGreen")
        button.setTitleColor(.green, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        button.layer.cornerRadius = button.frame.width / 2.0
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemBackground.cgColor// UIColor.red.cgColor//UIColor.clear.cgColor
        button.addTarget(self, action: #selector(startAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("Пауза", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .light)
        button.backgroundColor = UIColor(named: "SpecialYellow")
        button.setTitleColor(.systemOrange, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        button.layer.cornerRadius = button.frame.width / 2.0
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemBackground.cgColor
        button.addTarget(self, action: #selector(stopAction), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Далі", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .light)
        button.backgroundColor = UIColor(named: "SpecialGreen")
        button.setTitleColor(.green, for: .normal) //чомусь не працює колір
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        button.layer.cornerRadius = button.frame.width / 2.0
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemBackground.cgColor
        button.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
//    //MARK: - UI settings table
//    private let settingsTable: UITableView = {
//        let table = UITableView()
//        table.layer.backgroundColor = UIColor.clear.cgColor
//        table.isScrollEnabled = false
//        table.separatorStyle = .none
//        table.showsVerticalScrollIndicator = false
//        table.backgroundColor = .systemGray6
//        table.layer.cornerRadius = 10
//        table.translatesAutoresizingMaskIntoConstraints = false
//        table.register(SettingsTableCell.self, forCellReuseIdentifier: SettingsTableCell.identifier)
//        return table
//    }()
    
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // change bg
        view.backgroundColor = .systemBackground
        // add subviews
        addSubviews()
        // apply constraints
        applyConstraints()
        // apply delegates
        applyPickerViewDelegates()
        //applyTableViewDelegates()
    }
    

    //MARK: - add subviews
    private func addSubviews() {
        view.addSubview(timerPicker)
        view.addSubview(timeLabel)
        timerPicker.addSubview(labelHours)
        timerPicker.addSubview(labelMinutes)
        timerPicker.addSubview(labelSeconds)
        view.addSubview(circle)
        circle.addSubview(resetButton)
        view.addSubview(circle2)
        circle2.addSubview(startButton)
        circle2.addSubview(stopButton)
        circle2.addSubview(continueButton)
        //view.addSubview(settingsTable)
    }
    
    //MARK: - Convert to seconds
    //Розраховуємо кількість секунд для годин і хвилин - додаємо для загального рахунку від зазначеного на пікері значення і буде рахувати до 0. Далі у методах прописано як саме рахуватиме. Тобто буде сума секун від того загального часу, що ми вибрали на пікері.
    private func convertToSeconds(hours: Int, minutes: Int, seconds: Int) -> Int {
        
        let result = ((hours * 60) * 60) + (minutes * 60) + seconds
        return result
    }
    
    //MARK: - Update time lbl with correct time format
    //функція, яка конвертує усі секунди і розставляє їх по рядкам
    private func makeFullStringTime(seconds: Int) {
        var timeString = ""
            timeString += String(format: "%01d", seconds / 3600)
            timeString += ":"
            timeString += String(format: "%02d", (seconds % 3600) / 60)
            timeString += ":"
            timeString += String(format: "%02d", (seconds % 3600) % 60)
            timeLabel.text = timeString
            print(timeString)
    }
    
    //MARK: - Button Actions
    
    @objc func resetAction() {
        
        timer.invalidate()
        countDown = 0
        
        timerPicker.isHidden = false
        timeLabel.isHidden = true
        startButton.isHidden = false
        stopButton.isHidden = true
        continueButton.isHidden = true
        
        resetButton.setTitleColor(.gray, for: .normal)
        circle2.layer.borderColor = UIColor(named: "SpecialGreen")?.cgColor
        
        print("ResetButton clicked")
    }
    
    
    @objc func startAction() {
        
        let hours = timerPicker.selectedRow(inComponent: 0)
        let minutes = timerPicker.selectedRow(inComponent: 1)
        let seconds = timerPicker.selectedRow(inComponent: 2)
        
        print("\(hours):\(minutes):\(seconds)")
        
        if hours == 0 && minutes == 0 && seconds == 0 { // функція повертає нічого, якщо усі значення пікера == 0
            return
        }
        
        //викликаємо функцію, яка конвертує у секунди і сумує наші обрані на пикері значення.
        countDown = convertToSeconds(hours: hours, minutes: minutes, seconds: seconds)
        // change lbl instantly //викликаємо функцію, що розміщує значення на леблі з відліком часу
        makeFullStringTime(seconds: countDown)
        
        //запускаємо таймер
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownAction), userInfo: nil, repeats: true)
        
        print(countDown)
        
        timerPicker.isHidden = true
        timeLabel.isHidden = false
        stopButton.isHidden = false
        resetButton.setTitleColor(.white, for: .normal)
        circle2.layer.borderColor = UIColor(named: "SpecialYellow")?.cgColor
        
        print("StartButton clicked")
        
    }
    
    @objc func stopAction() {
        
        timer.invalidate()
        continueButton.isHidden = false
        circle2.layer.borderColor = UIColor(named: "SpecialGreen")?.cgColor
        
        print("StopButton clicked")
    }
    
    @objc func continueAction() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownAction), userInfo: nil, repeats: true)
        
        stopButton.isHidden = false
        continueButton.isHidden = true
        circle2.layer.borderColor = UIColor(named: "SpecialYellow")?.cgColor
       
        print("ContinueButton clicked")
    }
    
    //MARK: - Timer action
    @objc func countDownAction() {
        
        if countDown == 0 { //якщо лічильник вже завершив відлік і вже == 0
            //міняємо стан кнопок
            timerPicker.isHidden = false //знову показуємо пікер
            timeLabel.isHidden = true
            stopButton.isHidden = true
            startButton.isHidden = false
            resetButton.setTitleColor(.gray, for: .normal)
            circle2.layer.borderColor = UIColor(named: "SpecialGreen")?.cgColor
            
            countDown = 0 //обнуляємо лічильник
            timer.invalidate() //зупиняємо таймер
            
        } else {
            countDown -= 1 //якщо лічильник не 0 і ще рахує - віднімає значення на 1
            makeFullStringTime(seconds: countDown) //і передається наша лейбла зі значеннями часу, що спливає
        }
        
    }
    
    //MARK: - apply constraints
    private func applyConstraints() {
        
        let timerPickerConstraints = [
            timerPicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            timerPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            timerPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ]
        
        let timeLabelConstraints = [
            timeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 180),
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //доводиться вказувати константи, щоб не рухалася лейбла під час рахування часу
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 90),
            timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        
        let labelHoursConstraints = [
            labelHours.topAnchor.constraint(equalTo: timerPicker.centerYAnchor, constant: -10),
            labelHours.leadingAnchor.constraint(equalTo: timerPicker.leadingAnchor, constant: 85)
        ]
        
        let labelMinutesConstraints = [
            labelMinutes.topAnchor.constraint(equalTo: timerPicker.centerYAnchor, constant: -10),
            labelMinutes.leadingAnchor.constraint(equalTo: timerPicker.leadingAnchor, constant: 204)
        ]
        
        let labelSecondsConstraints = [
            labelSeconds.topAnchor.constraint(equalTo: timerPicker.centerYAnchor, constant: -10),
            labelSeconds.trailingAnchor.constraint(equalTo: timerPicker.trailingAnchor, constant: -40)
        ]
        
       let circleUnderResetButtonConstraints = [
            circle.topAnchor.constraint(equalTo: timerPicker.bottomAnchor, constant: 71),
            circle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            circle.widthAnchor.constraint(equalToConstant: 84),
            circle.heightAnchor.constraint(equalToConstant: 84)
        ]
        
        let resetButtonConstraints = [
            resetButton.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
            resetButton.centerYAnchor.constraint(equalTo: circle.centerYAnchor),
            resetButton.heightAnchor.constraint(equalToConstant: 80),
            resetButton.widthAnchor.constraint(equalToConstant: 80)
        ]
        
        let circleUnderStartButtonConstraints = [
             circle2.topAnchor.constraint(equalTo: timerPicker.bottomAnchor, constant: 71),
             circle2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
             circle2.widthAnchor.constraint(equalToConstant: 84),
             circle2.heightAnchor.constraint(equalToConstant: 84)
         ]
        
        let startButtonConstraints = [
            startButton.centerXAnchor.constraint(equalTo: circle2.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: circle2.centerYAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 80),
            startButton.widthAnchor.constraint(equalToConstant: 80)
        ]
        
        let stopButtonConstraints = [
            stopButton.centerXAnchor.constraint(equalTo: circle2.centerXAnchor),
            stopButton.centerYAnchor.constraint(equalTo: circle2.centerYAnchor),
            stopButton.heightAnchor.constraint(equalToConstant: 80),
            stopButton.widthAnchor.constraint(equalToConstant: 80)
        ]
        
        let continueButtonConstraints = [
            continueButton.centerXAnchor.constraint(equalTo: circle2.centerXAnchor),
            continueButton.centerYAnchor.constraint(equalTo: circle2.centerYAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 80),
            continueButton.widthAnchor.constraint(equalToConstant: 80)
        ]
        
//        let settingsTableConstraints = [
//            settingsTable.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 40),
//            settingsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            settingsTable.heightAnchor.constraint(equalToConstant: CGFloat(settings.count * 50)),
//            settingsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//        ]
//
        NSLayoutConstraint.activate(timerPickerConstraints)
        NSLayoutConstraint.activate(timeLabelConstraints)
        NSLayoutConstraint.activate(labelHoursConstraints)
        NSLayoutConstraint.activate(labelMinutesConstraints)
        NSLayoutConstraint.activate(labelSecondsConstraints)
        NSLayoutConstraint.activate(circleUnderResetButtonConstraints)
        NSLayoutConstraint.activate(resetButtonConstraints)
        NSLayoutConstraint.activate(circleUnderStartButtonConstraints)
        NSLayoutConstraint.activate(startButtonConstraints)
        NSLayoutConstraint.activate(stopButtonConstraints)
        NSLayoutConstraint.activate(continueButtonConstraints)
        //NSLayoutConstraint.activate(settingsTableConstraints)
       
    }
    
    //MARK: - Configure label
    //Конфіругуємо дані будильника так як ми самі обираємо дані для відображення
    public func configure(with model: TimerModel) {
        timeLabel.text = "\(model.hours):\(model.minutes):\(model.seconds)"
    }
}

//MARK: - UIPickerViewDelegate & DataSource
//екстешн для роботи пікера
extension TimerVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    private func applyPickerViewDelegates() {
        timerPicker.delegate = self
        timerPicker.dataSource = self
    }
    
    //Налаштовуємо кількість компонентів у пікера
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3 //компонентів у пікері 3 (по індексу воні передаються як 0(наш 1 масив з годинами), 1(наш другий масив з хвилинами) і 2(наш 3 масив з секундами))
    }
    //Кількість рядків в компоненті - тут так само як із секціями
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if component == 0 { //вказуємо що якщо 1 компонент (по індексу він 0)
//            return allHours.count //то повертаємо кількість рядків годин (тобто в масиві у нас їх 24 - у першому пікері з'явиться 24 значення)
//        } else if component == 1 { //на 2 компонент (тобто по індексу 1)
//            return allMinutes.count //ми повертаємо хвилини (буде 60 значень у пікери)
//        } else { //на 3 компонент
//            return allSeconds.count //ми повертаємо секунди (буде 60 значень у пікери)
//        }
        //кращий варіан зі switch
        switch component {
        case 0:
            return allHours.count
        case 1:
            return allMinutes.count
        case 2:
            return allSeconds.count
            
        default:
            return 0
        }
    }
    //передаємо значення для відображення в рядках
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //щоб не передавати значення з масивів - ми передаємо значення через індекси так як вони відповідні для значень годин і хвилин теж - тобто починаються від 0 і значення рівне своєму індексу. Едине треба для індексів від 0 до 9 треба попереду додати 0. Тож прописуємо далі умови для цього.
//        if component == 0 { //для першого масиву який у нас 0 за індексом
//            return "\(row)" //повертаємо просто значення індекса
//        } else if component == 1 { //інший компонент далі з такими ж умовами як і для першого
//            return "\(row)"
//        } else {
//            return "\(row)"
//            }
        //також, switch тут більше підходить
        switch component {
        case 0:
            return "\(row)"
        case 1:
            return "\(row)"
        case 2:
            return "\(row)"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //функція в якій можна встановити якусь дію, якщо обрана певна комбінація, наприклад
    }
}


////MARK: - UITableViewDelegate & DataSource
//extension TimerVC: UITableViewDelegate, UITableViewDataSource {
//
//    // apply delegates
//    private func applyTableViewDelegates() {
//        settingsTable.delegate = self
//        settingsTable.dataSource = self
//    }
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return settings.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableCell.identifier) as? SettingsTableCell else { return UITableViewCell()}
//
//        let model = settings[indexPath.row]
//
//        if model.accesorry {
//            cell.accessoryType = .disclosureIndicator
//        }
//
//        cell.configure(with: model)
//
//
//
//        return cell
//
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
//
//}

