package hex.control.trigger;

/**
 * ...
 * @author Francis Bourre
 */
class MVCTriggerSuite
{
	@Suite( "Trigger" )
    public var list : Array<Class<Dynamic>> = 
	[ 
		#if ( haxe_ver >= "3.3" )
		CommandTriggerTest, 
		CommandTriggerUserCaseTest,
		#end
		MacroCommandTest 
	];
}