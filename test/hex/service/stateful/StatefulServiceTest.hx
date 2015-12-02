package hex.service.stateful;
import hex.error.IllegalStateException;
import hex.service.ServiceConfiguration;
import hex.service.stateful.StatefulService;
import hex.service.stateless.MockStatelessService;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author duke
 */
class StatefulServiceTest
{
	public var service : MockStatefulService;
	
	@setUp
    public function setUp() : Void
    {
        this.service = new MockStatefulService();
    }

    @tearDown
    public function tearDown() : Void
    {
        this.service = null;
    }

	@test( "Test 'setConfiguration' method" )
    public function testSetConfiguration() : Void
    {
		var dummyConfig:ServiceConfiguration = new ServiceConfiguration();
		this.service.setConfiguration(dummyConfig);
		
		Assert.assertEquals(dummyConfig, this.service.getConfiguration(), "setted configuration should be returned" );
		
		this.service.run();
		Assert.assertMethodCallThrows( IllegalStateException, this.service, this.service.setConfiguration, [dummyConfig], "StatefulService should throw IllegalStateException when calling setConfiguration when in use" );
		
		this.service.stop();
		
		Assert.assertEquals(dummyConfig, this.service.getConfiguration(), "should be able to call setConfiguration after _release called" );
	}
	
	@test( "Test 'lock' and 'release' behavion" )
    public function testLockAndRelease() : Void
    {
		trace("apple", this.service.inUse);
		Assert.failTrue( this.service.inUse, "the inUse property should be false by default" );
		
		this.service.run();
		
		Assert.assertTrue( this.service.inUse, "the inUse property should be true after _lock called" );
		
		this.service.stop();
		
		Assert.failTrue( this.service.inUse, "the inUse property should be false after _release called" );
	}
	
	@test( "event subscription" )
    public function testEventSubscriptions() : Void
	{
		//TODO: implement these tests - grosmar
	}
}

