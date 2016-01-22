package hex.service.stateless.http;

/**
 * ...
 * @author Francis Bourre
 */
class HTTPSuite
{
	@Suite("HTTP suite")
    public var list : Array<Class<Dynamic>> = [HTTPServiceTest, DefaultHTTPServiceParameterFactoryTest];
}