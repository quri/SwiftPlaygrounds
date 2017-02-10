public
struct Distance
{
    // Base unit is meters
    fileprivate var metersValue: Double = 0

    public
    init(_ length: Double, unit: Unit)
    {
        self.metersValue = length * unit.coefficient
    }

    public
    enum Unit: String
    {
        case feet       = "ft"
        case kilometers = "km"
        case meters     = "m"
        case miles      = "mi"

        internal var coefficient: Double
        {
            switch self
            {
            case .feet:
                return 0.3048
            case .kilometers:
                return 1000
            case .meters:
                return 1
            case .miles:
                return 1609.34
            }
        }
    }

    public
    func `in`(_ unit: Unit) -> Double
    {
        return self.metersValue / unit.coefficient
    }

    public
    func inUnits(unit: Unit) -> Double
    {
        return `in`(unit)
    }
}

extension Distance: Comparable { }

public
func == (lhs: Distance, rhs: Distance) -> Bool
{
    return lhs.in(.meters) == rhs.in(.meters)
}

public
func < (lhs: Distance, rhs: Distance) -> Bool
{
    return lhs.in(.meters) < rhs.in(.meters)
}

public
func <= (lhs: Distance, rhs: Distance) -> Bool
{
    return lhs.in(.meters) <= rhs.in(.meters)
}

public
func > (lhs: Distance, rhs: Distance) -> Bool
{
    return lhs.in(.meters) > rhs.in(.meters)
}

public
func >= (lhs: Distance, rhs: Distance) -> Bool
{
    return lhs.in(.meters) >= rhs.in(.meters)
}

public
func + (lhs: Distance, rhs: Distance) -> Distance
{
    return Distance(lhs.`in`(.meters) + rhs.in(.meters), unit: .meters)
}

public
func - (lhs: Distance, rhs: Distance) -> Distance
{
    return Distance(lhs.in(.meters) - rhs.in(.meters), unit: .meters)
}

public
func / (lhs: Distance, rhs: Double) -> Distance
{
    return Distance(lhs.in(.meters) / rhs, unit: .meters)
}

public
func * (lhs: Distance, rhs: Double) -> Distance
{
    return Distance(lhs.in(.meters) * rhs, unit: .meters)
}

public
func * (lhs: Double, rhs: Distance) -> Distance
{
    return Distance(lhs * rhs.in(.meters), unit: .meters)
}

// MARK: Tests

let one_meter       = Distance(1, unit: .meters)
let thousand_meters = Distance(1000, unit: .meters)
let twelve_miles    = Distance(12, unit: .miles)
let one_kilometer   = Distance(1, unit: .kilometers)
let five_feet       = Distance(5, unit: .feet)

five_feet.in(.meters)
print("Twelve miles equal to \(twelve_miles.in(.kilometers)) kilometers")
print("Twelve miles equal to \(twelve_miles.in(.feet)) feet")

print("Is a thousand meters equal to one kilometer? \(thousand_meters == one_kilometer)")
print("Are twelve miles greater than five feet? \(twelve_miles > five_feet)")
print("Are five feet less than or equal to a meter? \(five_feet <= one_meter)")

print("What's twelve miles plus a thousand meters? \((twelve_miles + thousand_meters).in(.miles)) miles")
print("What's five feet times five? \((five_feet * 5).in(.feet)) feet")
print("What's one kilometer divided by two? \((one_kilometer / 2).in(.meters)) meters")
