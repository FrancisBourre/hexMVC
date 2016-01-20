package hex.service.stateless;
import hex.service.stateless.http.HTTPSuite;

/**
 * ...
 * @author Francis Bourre
 */
class MVCStatelessServiceSuite
{
	@suite("Stateless")
    public var list : Array<Class<Dynamic>> = [AsyncStatelessServiceTest, HTTPSuite, StatelessServiceTest];
}