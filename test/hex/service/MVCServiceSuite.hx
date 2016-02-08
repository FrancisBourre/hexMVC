package hex.service;

import hex.service.monitor.MVCMonitorSuite;
import hex.service.stateful.MVCStatefulServiceSuite;
import hex.service.stateless.MVCStatelessServiceSuite;

/**
 * ...
 * @author Francis Bourre
 */
class MVCServiceSuite
{
	@Suite( "Service" )
    public var list : Array<Class<Dynamic>> = [ MVCMonitorSuite, MVCStatelessServiceSuite, MVCStatefulServiceSuite, AbstractServiceTest, ServiceConfigurationTest, ServiceURLConfigurationTest ];
}