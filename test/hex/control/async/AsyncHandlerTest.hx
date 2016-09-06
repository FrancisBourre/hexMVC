package hex.control.async;

import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Tamas Kinsztler
 */
class AsyncHandlerTest
{
	@Test( "Test constructor" )
	public function testConstructor() : Void
	{
		var asyncCallback = new ASyncCommandListener();
		var asyncHandler = new AsyncHandler( asyncCallback.onAsyncCommandComplete );

		Assert.equals( asyncCallback.onAsyncCommandComplete, asyncHandler.callback, "method closures should be the same" );
	}
}

private class ASyncCommandListener implements IAsyncCommandListener
{
	public function new()
	{

	}

	public function onAsyncCommandComplete( cmd : IAsyncCommand ) : Void
	{

	}

	public function onAsyncCommandFail( cmd : IAsyncCommand ) : Void
	{

	}

	public function onAsyncCommandCancel( cmd : IAsyncCommand ) : Void
	{

	}
}
