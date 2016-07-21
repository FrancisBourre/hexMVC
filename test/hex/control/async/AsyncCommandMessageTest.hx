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
		Assert.isInstanceOf( AsyncCommandMessage.COMPLETE, MessageType, "onAsyncCommandComplete should be an instance of 'MessageType'" );
		Assert.equals( "onAsyncCommandComplete", AsyncCommandMessage.COMPLETE.name, "names should be the same" );
	}

	@Test( "Test 'onAsyncCommandFail'" )
	public function testOnAsyncCommandFail() : Void
	{
		Assert.isInstanceOf( AsyncCommandMessage.FAIL, MessageType, "'AsyncCommandMessage.FAIL' should be an instance of 'MessageType'" );
		Assert.equals( "onAsyncCommandFail", AsyncCommandMessage.FAIL.name, "names should be the same" );
	}

	@Test( "Test 'onAsyncCommandCancel'" )
	public function testOnAsyncCommandCancel() : Void
	{
		Assert.isInstanceOf( AsyncCommandMessage.CANCEL, MessageType, "'AsyncCommandMessage.CANCEL' should be an instance of 'MessageType'" );
		Assert.equals( "onAsyncCommandCancel", AsyncCommandMessage.CANCEL.name, "names should be the same" );
	}
}
