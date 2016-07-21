package hex.control.async;

import hex.event.MessageType;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Tamas Kinsztler
 */
class AsyncCommandMessageTest
{
		@Test( "Test 'onAsyncCommandComplete'" )
	  public function testOnAsyncCommandComplete() : Void
	  {
	    	var staticVariable = AsyncCommandMessage.COMPLETE;
        var message = new MessageType( "onAsyncCommandComplete" );
	      Assert.equals( message.name, staticVariable.name, "onAsyncCommandComplete should exist" );
	  }

    @Test( "Test 'onAsyncCommandFail'" )
	  public function testOnAsyncCommandFail() : Void
	  {
	    	var staticVariable = AsyncCommandMessage.FAIL;
        var message = new MessageType( "onAsyncCommandFail" );
	      Assert.equals( message.name, staticVariable.name, "onAsyncCommandFail should exist" );
	  }

    @Test( "Test 'onAsyncCommandCancel'" )
	  public function testOnAsyncCommandCancel() : Void
	  {
	    	var staticVariable = AsyncCommandMessage.CANCEL;
        var message = new MessageType( "onAsyncCommandCancel" );
	      Assert.equals( message.name, staticVariable.name, "onAsyncCommandCancel should exist" );
	  }
}
