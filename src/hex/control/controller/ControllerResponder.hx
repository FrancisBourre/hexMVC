package hex.control.controller;

/**
 * ...
 * @author Francis Bourre
 */
class ControllerResponder<ResultType> implements ICompletable<ResultType>
{
	var _asyncCommand : ICompletable<ResultType>;

	public function new( ?asyncCommand : ICompletable<ResultType> ) 
	{
		this._asyncCommand = asyncCommand;
	}
	
	public function onComplete( callback : ResultType->Void ) : ICompletable<ResultType>
	{
		this._asyncCommand.onComplete( callback );
		return this;
	}
	
	public function onFail( callback : String->Void ) : ICompletable<ResultType>
	{
		this._asyncCommand.onFail( callback );
		return this;
	}
}