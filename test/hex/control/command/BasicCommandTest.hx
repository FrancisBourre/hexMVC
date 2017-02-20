package hex.control.command;

import hex.module.MockModule;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Tamas Kinsztler
 */
class BasicCommandTest
{
	@Test( "Test 'getResult'" )
	public function testGetResult() : Void
	{
		var basicCommand = new BasicCommand();
		Assert.isNull( basicCommand.getResult(), "'getResult' should return null by default" );
	}

	@Test( "Test 'getReturnedExecutionPayload'" )
	public function testGetReturnedExecutionPayload() : Void
	{
		var basicCommand = new BasicCommand();
		Assert.isNull( basicCommand.getReturnedExecutionPayload(), "'getReturnedExecutionPayload' should return null by default" );
	}

	@Test( "Test getter/setter methods" )
	public function testGetterSetter() : Void
	{
		var basicCommand 	= new BasicCommand();
		Assert.isNull( basicCommand.getOwner(), "'getOwner' should return null by default" );

		var module 			= new MockModule();

		basicCommand.setOwner( module );
		Assert.equals( module, basicCommand.getOwner(), "'setOwner' should set the correct owner and 'getOwner' should return it" );
	}

	@Test( "Test 'getLogger'" )
	public function testgetLogger() : Void
	{
		var basicCommand 	= new BasicCommand();
		var module 			= new MockModule();

		basicCommand.setOwner( module );
		Assert.equals( module.getLogger(), basicCommand.getLogger(), "logger instances should be the same" );
	}
}
