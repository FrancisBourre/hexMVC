package hex.event;

import hex.error.Exception;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class CallbackAdapterTest
{
	var _callbackAdapter : CallbackAdapter;
	
	@Test( "Test getCallbackAdapter" )
    public function testGetCallbackAdapter() : Void
    {
		this._callbackAdapter = new CallbackAdapter();
		this._callbackAdapter.setCallBackMethod( this, this.simpleCallbackTest );
		this._callbackAdapter.setAdapterMethod( this, this.simpleAdapter );
		
		this.triggerCallbackAdapter( this._callbackAdapter.getCallbackAdapter() );
    }
	
	function triggerCallbackAdapter( callbackAdapter : Dynamic ) : Void
	{
		callbackAdapter( "hello" );
	}

	function simpleAdapter( s : String ) : Int
	{
		return 1;
	}
	
	function simpleCallbackTest( i : Int ) : Void
	{
		Assert.equals( 1, i, "'getCallbackAdapter' should return 1" );
	}
}