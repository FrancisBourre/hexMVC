package hex.control.async;

/**
 * ...
 * @author Francis Bourre
 */
class AsyncHandler
{
	public var scope 	: Dynamic;
	public var callback	: AsyncCommand->Void;

	public function new( scope : Dynamic, callback : AsyncCommand->Void ) 
	{
		this.scope = scope;
		this.callback = callback;
	}
}