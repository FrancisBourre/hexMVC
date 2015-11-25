package hex.service;

import hex.service.ServiceConfiguration;
import hex.service.ServiceURLConfiguration;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class ServiceURLConfigurationTest extends ServiceConfigurationTest
{
	@test( "Test 'serviceURL' parameter passed to constructor" )
    public function testServiceURL() : Void
    {
        var serviceUrl : String = "url";
        var serviceConfiguration : ServiceURLConfiguration = new ServiceURLConfiguration( serviceUrl );

        Assert.assertEquals( serviceUrl, serviceConfiguration.serviceUrl, "'serviceURL' property should be the same passed to constructor" );
    }
}