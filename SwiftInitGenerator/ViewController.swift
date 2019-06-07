//
//  ViewController.swift
//  SwiftInitGenerator
//
//  Created by ym on 2019/03/18.
//  Copyright © 2019 Yuto Mizutani. All rights reserved.
//

import RxCocoa
import RxSwift
import Cocoa

class ViewController: NSViewController {
    @IBOutlet var leftTextView: NSTextView!
    @IBOutlet var rightTextView: NSTextView!

    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        rightTextView.isEditable = false

        leftTextView.rx.string.asObservable()
            .throttle(1, latest: true, scheduler: MainScheduler.instance)
            .filter { !$0.isEmpty }
            .map { SwiftInitGenerator().generate($0) }
            .subscribe(onNext: { [weak self] in
                self?.rightTextView.string = $0
            })
            .disposed(by: disposeBag)
    }
}
