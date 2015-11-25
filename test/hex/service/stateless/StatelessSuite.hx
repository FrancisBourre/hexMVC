package hex.service.stateless;

import hex.service.stateless.http.HTTPSuite;

/**
 * ...
 * @author Francis Bourre
 */
class StatelessSuite
{
	@suite("Stateless suite")
    public var list : Array<Class<Dynamic>> = [AsyncStatelessServiceTest/*, HTTPSuite*/, StatelessServiceTest];
}