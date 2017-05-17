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
		CommandTriggerTest, 
		CommandTriggerUserCaseTest,
		MacroCommandTest,
		CommandTriggerAnnotationReplaceTest
	];
}