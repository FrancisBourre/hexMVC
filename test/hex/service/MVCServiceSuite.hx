package hex.service;

import hex.service.stateful.MVCStatefulServiceSuite;
import hex.service.stateless.MVCStatelessServiceSuite;

/**
 * ...
 * @author Francis Bourre
 */
class MVCServiceSuite
{
	@suite( "Service" )
    public var list : Array<Class<Dynamic>> = [MVCStatelessServiceSuite, MVCStatefulServiceSuite, AbstractServiceTest, ServiceConfigurationTest, ServiceEventTest, ServiceURLConfigurationTest];
}