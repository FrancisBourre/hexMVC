package hex.control.command;

/**
 * ...
 * @author Francis Bourre
 */
class MVCCommandSuite
{
	@suite("Command")
    public var list : Array<Class<Dynamic>> = [CommandExecutorTest, CommandMappingTest];
}