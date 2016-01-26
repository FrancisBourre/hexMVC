package hex.event;

/**
 * ...
 * @author Francis Bourre
 */
class AdapterStrategy implements IAdapterStrategy
{
	var _target 		: Dynamic;
	var _method 		: Dynamic;
	
	function new( target : Dynamic, method : Dynamic ) 
	{
		this._target = target;
		this._method = method;
	}
	
	public function adapt( args : Array<Dynamic> ) : Dynamic
	{
		return Reflect.callMethod( this._target, this._method, args );
	}
}