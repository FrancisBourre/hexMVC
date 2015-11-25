package hex.control.command;

/**
 * ...
 * @author Francis Bourre
 */
class CommandSuite
{
	@suite("Command suite")
    public var list : Array<Class<Dynamic>> = [CommandExecutorTest, CommandMappingTest];
}