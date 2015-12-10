package hex.event;

import hex.error.Exception;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class CallbackAdapterTest
{
	private var _callbackAdapter : CallbackAdapter;
	
	@test( "Test getCallbackAdapter" )
    public function testGetCallbackAdapter() : Void
    {
		this._callbackAdapter = new CallbackAdapter();
		this._callbackAdapter.setCallBackMethod( this, this.simpleCallbackTest );
		this._callbackAdapter.setAdapterMethod( this, this.simpleAdapter );
		
		this.triggerCallbackAdapter( this._callbackAdapter.getCallbackAdapter() );
    }
	
	private function triggerCallbackAdapter( callbackAdapter : Dynamic ) : Void
	{
		callbackAdapter( "hello" );
	}

	private function simpleAdapter( s : String ) : Int
	{
		return 1;
	}
	
	private function simpleCallbackTest( i : Int ) : Void
	{
		Assert.equals( 1, i, "'getCallbackAdapter' should return 1" );
	}
}