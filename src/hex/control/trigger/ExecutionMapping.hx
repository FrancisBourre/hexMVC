package hex.control.trigger;

import hex.control.guard.IGuard;

/**
 * ...
 * @author Francis Bourre
 */
class ExecutionMapping<ResultType> 
{
	var _commandClass 	: Class<Command<ResultType>>;
	var _guards 		: Array<Class<IGuard>>;

	public function new( commandClass : Class<Command<ResultType>> ) 
	{
		this._commandClass = commandClass;
	}
	
	public function getCommandClass() : Class<Command<ResultType>>
	{
		return this._commandClass;
	}
	
	@:isVar public var hasGuard( get, null ) : Bool;
	function get_hasGuard() : Bool
	{
		return this._guards != null;
	}
	
    public function getGuards() : Array<Class<IGuard>>
    {
        return this._guards;
    }
	
	public function withGuard( guard : Class<IGuard> ) : ExecutionMapping<ResultType> 
    {
        if ( this._guards == null )
        {
            this._guards = new Array<Class<IGuard>>();
        }

        this._guards.push( guard );
        return this;
    }
}