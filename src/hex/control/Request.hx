package hex.control;

import hex.control.payload.ExecutionPayload;

/**
 * ...
 * @author Francis Bourre
 */
class Request
{
	var _executionPayloads : Array<ExecutionPayload>;
	
	public function new( ?executionPayloads : Array<ExecutionPayload> ) 
	{
		this._executionPayloads = executionPayloads;
	}
	
	public function getExecutionPayloads() : Array<ExecutionPayload>
	{
		return this._executionPayloads;
	}
	
	public function clone() : Request
	{
		return new Request( this._executionPayloads );
	}
}