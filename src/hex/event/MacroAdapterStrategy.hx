package hex.event;

import hex.control.macro.Macro;

/**
 * ...
 * @author Francis Bourre
 */
class MacroAdapterStrategy extends Macro implements IAdapterStrategy
{
	private var _target 		: Dynamic;
	private var _method 		: Dynamic;
	private var _result 		: Array<Dynamic>;
		

	public function new( target : Dynamic, method : Dynamic ) 
	{
		this._target = target;
		this._method = method;
		
		super();
	}

	public function adapt( args : Array<Dynamic> ) : Dynamic
	{
		return Reflect.callMethod( this._target, this._method, args );
	}

	override public function getResult() : Array<Dynamic>
	{
		return this._result;
	}
}