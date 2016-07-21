package hex.control.command;

import hex.module.Module;
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
	      Assert.equals( "execute", basicCommand.executeMethodName, "constructor should create a BasicCommand with 'execute' executeMethodName" );
	  }

    @Test( "Test 'getResult'" )
	  public function testGetResult() : Void
	  {
        var basicCommand = new BasicCommand();
	      Assert.isNull( basicCommand.getResult(), "getResult should return with null" );
	  }

    @Test( "Test 'getReturnedExecutionPayload'" )
	  public function testGetReturnedExecutionPayload() : Void
	  {
        var basicCommand = new BasicCommand();
	      Assert.isNull( basicCommand.getReturnedExecutionPayload(), "getReturnedExecutionPayload should return with null" );
	  }

    @Test( "Test getter/setter methods" )
	  public function testGetterSetter() : Void
	  {
        var basicCommand = new BasicCommand();
        var module = new Module();
        basicCommand.setOwner( module );
        var owner = basicCommand.getOwner();
	      Assert.equals( module, owner, "setOwner should set the correct owner and getOwner should return it" );
	  }

    @Test( "Test 'getLogger'" )
	  public function testgetLogger() : Void
	  {
        var basicCommand = new BasicCommand();
        var module = new Module();
        basicCommand.setOwner( module );
        var logger = basicCommand.getLogger();
	      Assert.equals( "hex.log.DomainLogger", Type.getClassName( Type.getClass( logger ) ), "getLogger should return a domain logger object" );
	  }
}
