package hex.event;

#if (!neko || haxe_ver >= "3.3")
import hex.control.async.IAsyncCommand;
import hex.control.payload.ExecutionPayload;
import hex.event.MacroAdapterStrategy;

/**
 * ...
 * @author Francis Bourre
 */
class MockAdapterStrategyMacro extends MacroAdapterStrategy
{
	var _message : String;

	public function new()
	{
		super( this, this.onAdapt );
	}

	public function onAdapt( request : MockRequest, message : String ) : Void
	{
		this._request = request;
		this._message = message;
	}

	override function _prepare() : Void
	{
		this.add( MockAdapterStrategyCommand ).withPayload( new ExecutionPayload( this._message, String ) ).withCompleteHandler( this._end );
	}

	function _end( async : IAsyncCommand ) : Void
	{
		this._result = async.getResult();
	}
}
#end