public
enum Distance
{
    case feet(Double)
    case kilometers(Double)
    case meters(Double)
    case miles(Double)
    
    
    private
    enum ConversionConstant: Double
    {
        case feetToKilometers   = 0.0003048
        case feetToMeters       = 0.3048
        case feetToMiles        = 0.000189394
        case kilometersToFeet   = 3280.84
        case kilometersToMeters = 1000.0
        case kilometersToMiles  = 0.6213713910761
        case metersToFeet       = 3.28084
        case metersToKilometers = 0.001
        case metersToMiles      = 0.000621371192
        case milesToFeet        = 5280.0
        case milesToKilometers  = 1.60934
        case milesToMeters      = 1609.34
    }
    
    
    public
    func toFeet() -> Double
    {
        switch self
        {
        case .feet(let d):
            return d
        case .kilometers(let d):
            return d * ConversionConstant.kilometersToFeet.rawValue
        case .meters(let d):
            return d * ConversionConstant.metersToFeet.rawValue
        case .miles(let d):
            return d * ConversionConstant.milesToFeet.rawValue
        }
    }
    
    public
    func toKilometers() -> Double
    {
        switch self
        {
        case .feet(let d):
            return d * ConversionConstant.feetToKilometers.rawValue
        case .kilometers(let d):
            return d
        case .meters(let d):
            return d * ConversionConstant.metersToKilometers.rawValue
        case .miles(let d):
            return d * ConversionConstant.milesToKilometers.rawValue
        }
    }
    
    public
    func toMeters() -> Double
    {
        switch self
        {
        case .feet(let d):
            return d * ConversionConstant.feetToMeters.rawValue
        case .kilometers(let d):
            return d * ConversionConstant.kilometersToMeters.rawValue
        case .meters(let d):
            return d
        case .miles(let d):
            return d * ConversionConstant.milesToMeters.rawValue
        }
    }
    
    public
    func toMiles() -> Double
    {
        switch self
        {
        case .feet(let d):
            return d * ConversionConstant.feetToMiles.rawValue
        case .kilometers(let d):
            return d * ConversionConstant.kilometersToMiles.rawValue
        case .meters(let d):
            return d * ConversionConstant.metersToMiles.rawValue
        case .miles(let d):
            return d
        }
    }
}

extension Distance: Comparable { }

public
func ==(lhs: Distance, rhs: Distance) -> Bool
{
    return lhs.toMeters() == rhs.toMeters()
}

public
func <(lhs: Distance, rhs: Distance) -> Bool
{
    return lhs.toMeters() < rhs.toMeters()
}

public
func <=(lhs: Distance, rhs: Distance) -> Bool
{
    return lhs.toMeters() <= rhs.toMeters()
}

public
func >(lhs: Distance, rhs: Distance) -> Bool
{
    return lhs.toMeters() > rhs.toMeters()
}

public
func >=(lhs: Distance, rhs: Distance) -> Bool
{
    return lhs.toMeters() >= rhs.toMeters()
}

public
func +(lhs: Distance, rhs: Distance) -> Distance
{
    return Distance.meters(lhs.toMeters() + rhs.toMeters())
}

public
func -(lhs: Distance, rhs: Distance) -> Distance
{
    return Distance.meters(lhs.toMeters() - rhs.toMeters())
}

public
func /(lhs: Distance, rhs: Double) -> Distance
{
    return Distance.meters(lhs.toMeters() / rhs)
}

public
func *(lhs: Distance, rhs: Double) -> Distance
{
    return Distance.meters(lhs.toMeters() * rhs)
}

public
func *(lhs: Double, rhs: Distance) -> Distance
{
    return Distance.meters(lhs * rhs.toMeters())
}

// MARK: Tests

let one_meter       = Distance.meters(1)
let thousand_meters = Distance.meters(1000)
let twelve_miles    = Distance.miles(12)
let one_kilometer   = Distance.kilometers(1)
let five_feet       = Distance.feet(5)

five_feet.toMeters()
print("Twelve miles equal to \(twelve_miles.toKilometers()) kilometers")
print("Twelve miles equal to \(twelve_miles.toFeet()) feet")

print("Is a thousand meters equal to one kilometer? \(thousand_meters == one_kilometer)")
print("Are twelve miles greater than five feet? \(twelve_miles > five_feet)")
print("Are five feet less than or equal to a meter? \(five_feet <= one_meter)")

print("What's twelve miles plus a thousand meters? \((twelve_miles + thousand_meters).toMiles()) miles")
print("What's five feet times five? \((five_feet * 5).toFeet()) feet")
print("What's one kilometer divided by two? \((one_kilometer / 2).toMeters()) meters")