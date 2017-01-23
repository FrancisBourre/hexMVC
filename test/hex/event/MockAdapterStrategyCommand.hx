package hex.event;

#if (!neko || haxe_ver >= "3.3")
import haxe.Timer;
import hex.control.async.AsyncCommand;

/**
 * ...
 * @author Francis Bourre
 */
class MockAdapterStrategyCommand extends AsyncCommand
{
	public function new() 
	{
		super();
	}

	@Inject
	public var message : String;

	public function execute( request : MockRequest ) : Void
	{
		this.message += request.message;
		Timer.delay( this.testAsyncCallback, 50 );
	}
	
	override public function getResult() : Array<Dynamic> 
	{
		return [ message ];
	}

	function testAsyncCallback() : Void
	{
		this._handleComplete();
	}
}
#end