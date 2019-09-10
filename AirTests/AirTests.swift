//
//  AirTests.swift
//  AirTests
//
//  Created by Paweł Szudrowicz on 07/09/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import XCTest
import Moya
import Moya_SwiftyJSONMapper
import RxTest
import RxSwift
@testable import AirCondition

class AirTests: XCTestCase {

    var provider: MoyaProvider<AppService>!
    var providerAirly: MoyaProvider<AirlyService>!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var viewModel: RegistrationViewModel!
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        viewModel = RegistrationViewModel()
        provider = MoyaProvider<AppService>(stubClosure: MoyaProvider.immediatelyStub)
        providerAirly = MoyaProvider<AirlyService>(stubClosure: MoyaProvider.immediatelyStub)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetAllDevicesRequest() {
        provider.request(.getAllDevices(token: "debug")) { (result) in
            switch result {
            case let .success(resp):
                let data = try? resp.map(to: MultipleDevicesModel.self)
                guard let _ = data else {
                    XCTAssert(false)
                    return
                }
                //let x = String(data: resp.data, encoding: .utf8)!
                XCTAssertEqual(data!.array.first!.email, "pablo.szudrowicz@gmail.com")
                XCTAssertEqual(data!.array.first!.serial, "00001234")
                XCTAssertEqual(data!.array.first!.latitude!, 50.5)
                XCTAssertEqual(data!.array.first!.longitude!, 16.6)
            case .failure(_):
                XCTAssert(false)
            }
        }
    }

    
    func testGetAllTrackingSnapshotsRequest() {
        provider.request(.getAllTrackingSnapshots(token: "debug")) { (result) in
            switch result {
            case let .success(resp):
                let data = try? resp.map(to: TrackingSnapshotModel.self)
                guard let _ = data else {
                    XCTAssert(false)
                    return
                }
                //let x = String(data: resp.data, encoding: .utf8)!
                XCTAssertEqual(data!.dict[1]!.first!.createdOn, "2019-09-01")
                XCTAssertEqual(data!.dict[1]!.first!.CO!, 500)
                XCTAssertEqual(data!.dict[1]!.first!.humidity!, 45.9)
                XCTAssertEqual(data!.dict[1]!.first!.pm10!, 8)
                XCTAssertEqual(data!.dict[1]!.first!.pm25!, 7)
                XCTAssertEqual(data!.dict[1]!.first!.pm100!, 50)
                XCTAssertEqual(data!.dict[1]!.first!.pressure!, 1007.1)
            case .failure(_):
                XCTAssert(false)
            }
        }
    }
    
    func testGetHistorySnapshotsRequest() {
        provider.request(.getHistorySnapshots(token: "debug", serial: "test")) { (result) in
            switch result {
            case let .success(resp):
                let data = try? resp.map(to: HistorySnapshotModel.self)
                guard let _ = data else {
                    XCTAssert(false)
                    return
                }
                //let x = String(data: resp.data, encoding: .utf8)!
                XCTAssertEqual(data!.array.first!.createdOn, "2019-09-01")
                XCTAssertEqual(data!.array.first!.CO!, 500)
                XCTAssertEqual(data!.array.first!.humidity!, 45.9)
                XCTAssertEqual(data!.array.first!.pm10!, 8)
                XCTAssertEqual(data!.array.first!.pm25!, 7)
                XCTAssertEqual(data!.array.first!.pm100!, 50)
                XCTAssertEqual(data!.array.first!.pressure!, 1007.1)
            case .failure(_):
                XCTAssert(false)
            }
        }
    }
    
    func testGetNearestInstallationsRequest() {
        providerAirly.request(.nearestInstallations(latitude: 16.6, longitude: 51.1, distance: 10)) { (result) in
            switch result {
            case let .success(resp):
                let data = try? resp.map(to: AirlyNearestDevice.self)
                guard let _ = data else {
                    XCTAssert(false)
                    return
                }
                //let x = String(data: resp.data, encoding: .utf8)!
                XCTAssertEqual(data!.array.first!.city!, "Poznan")
                XCTAssertEqual(data!.array.first!.id, 1)
                XCTAssertEqual(data!.array.first!.street!, "Dominikanska")
            case .failure(_):
                XCTAssert(false)
            }
        }
    }
    
    func testRegistrationIsValid() {
        let valid = scheduler.createObserver(Bool.self)
        viewModel.output.valid.bind(to: valid).disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, "pablo.szudrowicz@gmail.com"), .next(20, "pablo.szudrowiczgmail.com")]).bind(to: viewModel.input.email).disposed(by: disposeBag)
        scheduler.createColdObservable([.next(10, "pasdfasdf"), .next(20, "pasdfasdf")]).bind(to: viewModel.input.password).disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(valid.events, [.next(0, false), .next(10, true), .next(20, false)])
    }
}
