package hex.event;

/**
 * ...
 * @author Francis Bourre
 */
class AdapterStrategy implements IAdapterStrategy
{
	private var _target 		: Dynamic;
	private var _method 		: Dynamic;
	
	private function new( target : Dynamic, method : Dynamic ) 
	{
		this._target = target;
		this._method = method;
	}
	
	public function adapt( args : Array<Dynamic> ) : Dynamic
	{
		return Reflect.callMethod( this._target, this._method, args );
	}
}