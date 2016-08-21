package hex.control.async;

/**
 * ...
 * @author Francis Bourre
 */
class AsyncHandler
{
	public var scope 	: Dynamic;
	public var callback	: IAsyncCommand->Void;

	public function new( scope : Dynamic, callback : IAsyncCommand->Void ) 
	{
		this.scope = scope;
		this.callback = callback;
	}
}