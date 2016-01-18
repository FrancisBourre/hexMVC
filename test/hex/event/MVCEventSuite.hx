package hex.event;

/**
 * ...
 * @author Francis Bourre
 */
class MVCEventSuite
{
	@suite("event")
    public var list : Array<Class<Dynamic>> = [CallbackAdapterTest, ClassAdapterTest, EventProxyTest];
}