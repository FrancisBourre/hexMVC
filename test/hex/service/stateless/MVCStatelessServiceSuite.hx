package hex.service.stateless;

/**
 * ...
 * @author Francis Bourre
 */
class MVCStatelessServiceSuite
{
	@suite("Stateless")
    public var list : Array<Class<Dynamic>> = [AsyncStatelessServiceTest/*, HTTPSuite*/, StatelessServiceTest];
}