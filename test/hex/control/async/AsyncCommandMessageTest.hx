package hex.control.async;

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
		Assert.equals( "onAsyncCommandComplete", AsyncCommandMessage.COMPLETE, "names should be the same" );
	}

	@Test( "Test 'onAsyncCommandFail'" )
	public function testOnAsyncCommandFail() : Void
	{
		Assert.equals( "onAsyncCommandFail", AsyncCommandMessage.FAIL, "names should be the same" );
	}

	@Test( "Test 'onAsyncCommandCancel'" )
	public function testOnAsyncCommandCancel() : Void
	{
		Assert.equals( "onAsyncCommandCancel", AsyncCommandMessage.CANCEL, "names should be the same" );
	}
}
