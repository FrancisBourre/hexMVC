package hex.event;

import hex.control.payload.ExecutionPayload;

/**
 * ...
 * @author Francis Bourre
 */
class MockMacroAdapterStrategy extends MacroAdapterStrategy
{
	var data0 : MockValueObject;
	var data1 : MockValueObject;
	
	public function new()
	{
		super( this, this.onAdapt );
	}
	
	override function _prepare() : Void
	{
		this.add( MockAsyncCommand ).withPayload( new ExecutionPayload( data0, MockValueObject ) );
		this.add( MockAsyncCommand ).withPayload( new ExecutionPayload( data1, MockValueObject ) );
	}

	public function onAdapt( data0 : MockValueObject, data1 : MockValueObject ) : Void
	{
		this.data0 = data0;
		this.data1 = data1;
	}
	
	override public function getResult() : Array<Dynamic> 
	{
		return [ this.data0, this.data1 ];
	}
}