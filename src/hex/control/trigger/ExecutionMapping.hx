package hex.control.trigger;

/**
 * ...
 * @author Francis Bourre
 */
class ExecutionMapping<ResultType> 
{
	var _commandClass : Class<Command<ResultType>>;

	public function new( commandClass : Class<Command<ResultType>> ) 
	{
		this._commandClass = commandClass;
	}
	
	public function getCommandClass() : Class<Command<ResultType>>
	{
		return this._commandClass;
	}
}