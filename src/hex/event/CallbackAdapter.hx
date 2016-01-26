package hex.event;

/**
 * ...
 * @author Francis Bourre
 */
class CallbackAdapter
{
	var _callbackTarget 	: Dynamic;
	var _callbackMethod 	: Dynamic;
	
	var _adapterTarget 		: Dynamic;
	var _adapterMethod 		: Dynamic;

	public function new() 
	{
		
	}
	
	public function setCallBackMethod( callbackTarget : Dynamic, callbackMethod : Dynamic ) : Void
	{
		this._callbackTarget = callbackTarget;
		this._callbackMethod = callbackMethod;
	}

	public function setAdapterMethod( adapterTarget : Dynamic, adapterMethod : Dynamic ) : Void
	{
		this._adapterTarget = adapterTarget;
		this._adapterMethod = adapterMethod;
	}
	
	public function getCallbackAdapter() : Dynamic
	{
		var adapterTarget 		: Dynamic = null;
		var adapterMethod 		: Dynamic = null;
		
		var callbackTarget 		: Dynamic = this._callbackTarget;
		var callbackMethod 		: Dynamic = this._callbackMethod;
		
		if ( this._adapterTarget != null && this._adapterMethod != null )
		{
			adapterTarget = this._adapterMethod;
			adapterMethod = this._adapterMethod;
		}

		var f : Array<Dynamic>->Void = function ( rest : Array<Dynamic> ) : Void
		{
			var result : Dynamic = null;

			if ( adapterTarget != null && adapterMethod != null )
			{
				result = Reflect.callMethod( adapterTarget, adapterMethod, rest );
			}

			Reflect.callMethod( callbackTarget, callbackMethod, [result] );
		}
		
		return Reflect.makeVarArgs( f );
	}
}