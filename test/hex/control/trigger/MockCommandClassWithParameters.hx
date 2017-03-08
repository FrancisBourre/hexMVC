package hex.control.trigger;

import haxe.Timer;
import hex.collection.ILocator;
import hex.control.trigger.Command;

/**
 * ...
 * @author Francis Bourre
 */
class MockCommandClassWithParameters extends Command<String>
{
	public static var callCount 	: UInt = 0;
	public static var test 			: CommandTriggerTest;
	public static var message 		: String;
	public static var ignored 		: String;
	
	@Inject('text')
	public var textArg : String;
	
	@Inject
	public var testArg : CommandTriggerTest;
	
	@Inject
	@Optional( true )
	public var ignoredText : String;
	
	@Inject
	public var locator : ILocator<String, Bool>;
	
	@Inject
	public function new() 
	{
		super();
	}
	
	override public function execute() : Void
	{
		Timer.delay( this._end, 50 );
	}
	
	function _end() : Void
	{
		MockCommandClassWithParameters.callCount++;
		MockCommandClassWithParameters.message = this.textArg;
		MockCommandClassWithParameters.test = this.testArg;
		MockCommandClassWithParameters.ignored = this.ignoredText;
		
		this._complete( this.textArg );
	}
}