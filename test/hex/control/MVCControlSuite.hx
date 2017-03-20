package hex.control;

import hex.control.async.MVCAsyncSuite;
import hex.control.command.MVCCommandSuite;
import hex.control.guard.CoreGuardSuite;
import hex.control.macro.MVCMacroSuite;
import hex.control.trigger.MVCTriggerSuite;

/**
 * ...
 * @author Francis Bourre
 */
class MVCControlSuite
{
	@Suite("Control")
    public var list : Array<Class<Dynamic>> = 
	[ 
		CoreGuardSuite, 
		FrontControllerTest, 
		MVCAsyncSuite, 
		MVCCommandSuite, 
		MVCMacroSuite, 
		MVCTriggerSuite, 
		RequestTestWithGuard,
		RequestTestWithTypedefMapped,
		RequestTestWithEnumMapped,
		RequestTestWitAbstractMapped,
		RequestTestWithMapMapped,
		RequestTestWithMacro
	];
}