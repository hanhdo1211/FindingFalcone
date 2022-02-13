struct SelectVehicleItem {
    let text: String
    let action: ButtonAction
    
    init(text: String, action: @escaping ButtonAction) {
        self.text = text
        self.action = action
    }
}
