package hex.event;

import hex.event.IEvent;

/**
 * ...
 * @author Francis Bourre
 */
class EventProxy implements IEventListener
{
	public var target 						: Dynamic;
	public var method 						: Dynamic;
	public var appendEventToArguments 		: Bool;
	public var arguments 					: Array<Dynamic>;
	
	public function new( ?target : Dynamic, ?method : Dynamic, ?appendEventToArguments : Bool = true, arguments : Array<Dynamic> ) 
	{
		this.target 				= target;
		this.method 				= method;
		this.arguments 				= arguments;
	}

	public function handleEvent( e : IEvent ) : Void 
	{
		if ( this.target != null && this.method != null )
		{
			if ( this.appendEventToArguments )
			{
				Reflect.callMethod( this.target, this.method, this.arguments.concat( [e] ) );
			}
			else
			{
				Reflect.callMethod( this.target, this.method, this.arguments );
			}
		}
	}
}