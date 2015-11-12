package service;

import service.stateless.StatelessSuite;

/**
 * ...
 * @author Francis Bourre
 */
class ServiceSuite
{
	@suite("Service suite")
    public var list : Array<Class<Dynamic>> = [StatelessSuite, AbstractServiceTest, ServiceConfigurationTest, ServiceEventTest, ServiceURLConfigurationTest];
}