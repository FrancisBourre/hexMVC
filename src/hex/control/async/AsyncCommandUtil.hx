package hex.control.async;

import hex.error.PrivateConstructorException;

/**
 * ...
 * @author Francis Bourre
 */
class AsyncCommandUtil
{

	public function new() 
	{
		throw new PrivateConstructorException( "'AsyncCommandUtil' class can't be instantiated." );
	}
	
	static public function addListenersToAsyncCommand( listeners : Array<AsyncCommandEvent->Void>, methodToAddListener : ( AsyncCommandEvent->Void )->Void ) : Void
    {
        for ( listener in listeners )
        {
            methodToAddListener( listener );
        }
    }
}