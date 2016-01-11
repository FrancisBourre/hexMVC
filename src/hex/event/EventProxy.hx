package hex.event;

/**
 * ...
 * @author Francis Bourre
 */
class EventProxy
{
	public var target 						: Dynamic;
	public var method 						: Dynamic;
	
	public function new( target : Dynamic, method : Dynamic ) 
	{
		this.target 				= target;
		this.method 				= method;
	}
	
	public function handleCallback( args : Array<Dynamic> ) : Void 
	{
		if ( this.target != null && this.method != null )
		{
			Reflect.callMethod( this.target, this.method, args );
		}
	}
}