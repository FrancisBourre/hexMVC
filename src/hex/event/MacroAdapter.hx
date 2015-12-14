package hex.event;

import hex.control.macro.Macro;

/**
 * ...
 * @author Francis Bourre
 */
class MacroAdapter extends Macro implements IAdapterStrategy
{
	private var _target 		: Dynamic;
	private var _method 		: Dynamic;
	private var _payload 		: Array<Dynamic>;
		

	public function new( target : Dynamic, method : Dynamic ) 
	{
		this._target = target;
		this._method = method;
		
		super();
	}

	public function adapt( args : Array<Dynamic> ) : Array<Dynamic>
	{
		return Reflect.callMethod( this._target, this._method, args );
	}

	override public function getPayload() : Array<Dynamic>
	{
		return this._payload;
	}

	public function setPayload( payload : Array<Dynamic> ) : Void
	{
		this._payload = payload;
	}
}