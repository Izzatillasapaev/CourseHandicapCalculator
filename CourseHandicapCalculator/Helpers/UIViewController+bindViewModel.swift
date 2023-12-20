import UIKit
import Combine

public extension UIViewController {
    func bindViewModel<Event, Action>(_ viewModel: ViewModel<Event, Action>,
                                  handler: @escaping (Event) -> Void) -> AnyCancellable {
        viewModel
            .events
            .receiveOnMainQueue()
            .sink { event in
                handler(event)
            }
    }
}
