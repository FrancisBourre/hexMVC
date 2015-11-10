package service;

import hex.service.ServiceConfiguration;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class ServiceConfigurationTest
{
	@test( "Test 'serviceTimeout' default value from constructor" )
    public function testDefaultServiceTimeout() : Void
    {
        var serviceConfiguration : ServiceConfiguration = new ServiceConfiguration();

        Assert.assertEquals( 5000, serviceConfiguration.serviceTimeout, "'serviceTimeout' property value should be 5000 by default" );
    }
	
	@test( "Test 'serviceTimeout' parameter passed to constructor" )
    public function testServiceTimeout() : Void
    {
        var serviceTimeout : UInt = 400;
        var serviceConfiguration : ServiceConfiguration = new ServiceConfiguration( serviceTimeout );

        Assert.assertEquals( serviceTimeout, serviceConfiguration.serviceTimeout, "'serviceTimeout' property should be the same passed to constructor" );
    }
}