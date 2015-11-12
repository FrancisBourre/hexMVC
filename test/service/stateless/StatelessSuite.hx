package service.stateless;

/**
 * ...
 * @author Francis Bourre
 */
class StatelessSuite
{
	@suite("Stateless suite")
    public var list : Array<Class<Dynamic>> = [AsyncStatelessServiceEventTest, AsyncStatelessServiceTest, StatelessServiceEventTest, StatelessServiceTest];
}