package hex.control.trigger.mock;

#if ( haxe_ver >= "3.3" )
import hex.collection.Locator;
import hex.control.async.IAsyncCallback;
import hex.control.async.Nothing;
import hex.control.trigger.ICommandTrigger;

/**
 * ...
 * @author Francis Bourre
 */
class MockController 
	implements ICommandTrigger
	implements IMockController 
{
	public function new(){}
	
	@Map( hex.control.trigger.MockCommandClassWithoutParameters )
	public function print() : IAsyncCallback<Nothing>;
	
	@Map( hex.control.trigger.MockCommandClassWithParameters )
	public function say( 
							@Name( 'text' ) 								text 		: String, 
																			sender 		: CommandTriggerTest, 
							@Ignore 										anotherText : String,
							@Type( 'hex.collection.ILocator<String,Bool>' ) locator 	: Locator<String, Bool> 
						) : IAsyncCallback<String>;

	public function sum( a : Int, b : Int ) : Int 
	{ 
		return a + b;
	}
}
#end