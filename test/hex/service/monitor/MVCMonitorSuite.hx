package hex.service.monitor;

import hex.service.monitor.http.BasicHTTPServiceErrorStrategyTest;

/**
 * ...
 * @author Francis Bourre
 */
class MVCMonitorSuite
{
	@Suite( "Monitor" )
    public var list : Array<Class<Dynamic>> = [ BasicHTTPServiceErrorStrategyTest ];
}