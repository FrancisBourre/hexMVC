package hex.event;

import hex.error.IllegalArgumentException;

/**
 * ...
 * @author Francis Bourre
 */
class EventProxy
{
	public var scope 						: Dynamic;
	public var callback 					: Dynamic;
	
	public function new( scope : Dynamic, method : Dynamic ) 
	{
		this.scope 				= scope;
		this.callback 			= method;
	}
	
	public function handleCallback( args : Array<Dynamic> ) : Void 
	{
		if ( this.scope != null && this.callback != null )
		{
			Reflect.callMethod( this.scope, this.callback, args );
		}
		else
		{
			throw new IllegalArgumentException( "handleCallback call failed with method '" + callback  + " and scope '" + scope + "'" );
		}
	}
}