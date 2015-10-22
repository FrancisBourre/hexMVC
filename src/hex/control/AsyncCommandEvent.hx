package hex.control;

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
}
