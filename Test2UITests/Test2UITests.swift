//
//  Test2UITests.swift
//  Test2UITests
//
//  Created by Tatyana Sidoryuk on 10.05.2023.
//

import XCTest

final class Test2UITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
    }
    
        func testAddingImageToFavorites() {
        let app = XCUIApplication()
        app.launch()

        // Находим текстовое поле, вводим в него текст запроса и нажимаем кнопку "Сгенерировать"
        let queryTextField = app.textFields["queryTextField"]
        queryTextField.tap()
        queryTextField.typeText("cute puppies")
        app.buttons["generateButton"].tap()

        // Проверяем, что появилось изображение
        let imageView = app.images["imageView"]
        XCTAssertTrue(imageView.exists)
        
        // Нажимаем кнопку "Добавить в избранное"
        app.buttons["addToFavoritesButton"].tap()
        
        // Проверяем, что появилось сообщение об успешном добавлении в избранное
        let alert = app.alerts["Успех"]
        XCTAssertTrue(alert.exists)
        
        // Нажимаем кнопку "OK" в сообщении об успешном добавлении в избранное
        alert.buttons["OK"].tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
