package hex.model;

/**
 * ...
 * @author Francis Bourre
 */
class ModelDispatcher implements IModelDispatcher
{
	private var _listeners : Array<IModelListener> = [];
	
	public function new() 
	{
		
	}

	public function addListener( listener : IModelListener ) : Bool
	{
		if ( this._listeners.indexOf( listener ) == -1 )
		{
			this._listeners.push( listener );
			return true;
		}
		else
		{
			return false;
		}
	}

	public function removeListener( listener : IModelListener ) : Bool
	{
		var index : Int = this._listeners.indexOf( listener );
		
		if ( index > -1 )
		{
			this._listeners.splice( index, 1 );
			return true;
		}
		else
		{
			return false;
		}
	}
}