package hex.control.async;

/**
 * ...
 * @author Francis Bourre
 */
class AsyncHandler
{
	public var callback	: IAsyncCommand->Void;

	public function new( callback : IAsyncCommand->Void ) 
	{
		this.callback = callback;
	}
}