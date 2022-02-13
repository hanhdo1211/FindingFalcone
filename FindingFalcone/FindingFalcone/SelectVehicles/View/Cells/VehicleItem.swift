final class VehicleItem {
    let name: String
    let speed: Int
    let totalSlots: Int
    private (set) var availableSlots: Int = 0
    let maxDistance: Int
    
    init(
        name: String,
        speed: Int,
        totalSlots: Int,
        maxDistance: Int
    ) {
        self.name = name
        self.speed = speed
        self.totalSlots = totalSlots
        self.availableSlots = totalSlots
        self.maxDistance = maxDistance
    }
    
    func updateAvailableSlots(value: Int) {
        availableSlots = value
    }
}
