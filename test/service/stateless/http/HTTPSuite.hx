package service.stateless.http;

/**
 * ...
 * @author Francis Bourre
 */
class HTTPSuite
{
	@suite("HTTP suite")
    public var list : Array<Class<Dynamic>> = [HTTPServiceTest];
}