package hex.config.stateful;

/**
 * ...
 * @author Francis Bourre
 */
class StatefulSuite
{
	@suite("Stateful suite")
    public var list : Array<Class<Dynamic>> = [ServiceLocatorTest];
}