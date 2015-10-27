package hex.control;
import hex.event.BasicEvent;

/**
 * ...
 * @author Francis Bourre
 */
class PayloadEvent extends BasicEvent
{
	private var _executionPayloads : Array<ExecutionPayload>;
	
	public function new( type : String, target : Dynamic, executionPayloads : Array<ExecutionPayload> ) 
	{
		super( type, target );
		this._executionPayloads = executionPayloads;
	}
	
	public function getExecutionPayloads() : Array<ExecutionPayload>
	{
		return this._executionPayloads;
	}
	
	override public function clone() : BasicEvent
	{
		return new PayloadEvent( this.type, this.target, this._executionPayloads );
	}
}