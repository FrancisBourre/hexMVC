package hex.control.command;

/**
 * ...
 * @author Francis Bourre
 */
class MVCCommandSuite
{
	@Suite("Command")
    public var list : Array<Class<Dynamic>> = [CommandExecutorTest, CommandMappingTest];
}