import Foundation
import Combine

open class ViewModel<Event, Action>: NSObject {
    private(set) var events = PassthroughSubject<Event, Never>()
    private(set) var actions = PassthroughSubject<Action, Never>()
    
    var bag = Bag()
    
    public override init() {
        super.init()
        setupActionHandlers()
    }
    
    public func sendAction(_ action: Action) {
        actions.send(action)
    }
    
    public func sendEvent(_ event: Event) {
        events.send(event)
    }
    
    func setupActionHandlers() {
        actions.sink { [weak self] action in
            self?.handleAction(action)
        }.store(in: &bag)
    }
    
    open func handleAction(_ action: Action) {
        
    }
}
