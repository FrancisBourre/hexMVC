package hex.control.command;

/**
 * ...
 * @author Francis Bourre
 */
class MVCCommandSuite
{
		@Suite("Command")
    public var list : Array<Class<Dynamic>> = [BasicCommandTest, 
	#if (!neko || haxe_ver >= "3.3")
	CommandExecutorTest, 
	#end
	CommandMappingTest ];
}
