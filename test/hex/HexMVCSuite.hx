package hex;

import hex.config.MVCConfigSuite;
import hex.control.MVCControlSuite;
import hex.event.MVCEventSuite;
import hex.module.MVCModuleSuite;
import hex.service.MVCServiceSuite;
import hex.viewhelper.MVCViewHelperSuite;

/**
 * ...
 * @author Francis Bourre
 */
class HexMVCSuite
{
	@suite( "HexMVC" )
    public var list : Array<Class<Dynamic>> = [MVCConfigSuite, MVCControlSuite, MVCEventSuite, MVCModuleSuite, MVCServiceSuite, MVCViewHelperSuite];
}