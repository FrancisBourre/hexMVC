package;

import control.ControlSuite;
import service.ServiceSuite;

/**
 * ...
 * @author Francis Bourre
 */
class HexMVCSuite
{
	@suite( "HexMVC suite" )
    public var list : Array<Class<Dynamic>> = [ControlSuite, ServiceSuite];
}