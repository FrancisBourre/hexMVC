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
				var asyncScope = "constructor";
				var asyncCallback = new ASyncCommandListener();
	    	var asyncHandler = new AsyncHandler( asyncScope , asyncCallback.onAsyncCommandComplete );

	      Assert.equals( asyncScope, asyncHandler.scope, "scope parameter should be set by constructor" );
				Assert.equals( 'hex.control.async._AsyncHandlerTest.ASyncCommandListener', Type.getClassName( Type.getClass( asyncCallback ) ), "callback parameter should be set by constructor" );
	  }
}

private class ASyncCommandListener implements IAsyncCommandListener
{
		public function new()
		{

		}

		public function onAsyncCommandComplete( cmd : AsyncCommand ) : Void
		{

		}

		public function onAsyncCommandFail( cmd : AsyncCommand ) : Void
		{

		}

		public function onAsyncCommandCancel( cmd : AsyncCommand ) : Void
		{

		}
}
