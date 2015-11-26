package hex.control.async;

import hex.control.async.IAsyncCommand;
import hex.event.BasicEvent;

/**
 * ...
 * @author Francis Bourre
 */
class AsyncCommandEvent extends BasicEvent
{
    public inline static var COMPLETE       : String = "onAsyncCommandComplete";
    public inline static var FAIL           : String = "onAsyncCommandFail";
    public inline static var CANCEL         : String = "onAsyncCommandCancel";

    public function new ( eventType : String, target : IAsyncCommand )
    {
        super( eventType, target );
    }
	
	public function getAsyncCommand() : IAsyncCommand
	{
		return cast target;
	}
	
	override public function clone():BasicEvent 
	{
		return new AsyncCommandEvent(this.type, this.target);
	}
	
}
