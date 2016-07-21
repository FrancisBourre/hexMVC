package hex.control.command;

import hex.module.MockModule;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Tamas Kinsztler
 */
class BasicCommandTest
{
	@Test( "Test constructor" )
	public function testConstructor() : Void
	{
		var basicCommand = new BasicCommand();
		Assert.equals( "execute", basicCommand.executeMethodName, "method names should be the same" );
	}

	@Test( "Test 'getResult'" )
	public function testGetResult() : Void
	{
		var basicCommand = new BasicCommand();
		Assert.isNull( basicCommand.getResult(), "getResult should return null by default" );
	}

	@Test( "Test 'getReturnedExecutionPayload'" )
	public function testGetReturnedExecutionPayload() : Void
	{
		var basicCommand = new BasicCommand();
		Assert.isNull( basicCommand.getReturnedExecutionPayload(), "getReturnedExecutionPayload should return null by default" );
	}

	@Test( "Test getter/setter methods" )
	public function testGetterSetter() : Void
	{
		var basicCommand 	= new BasicCommand();
		var module 			= new MockModule();

		basicCommand.setOwner( module );
		var owner = basicCommand.getOwner();

		Assert.equals( module, owner, "'setOwner' should set the correct owner and 'getOwner' should return it" );
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
