package hex.control.trigger.mock;

import hex.collection.Locator;
import hex.control.async.Expect;
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
	public function print() : Expect<Nothing>;
	
	@Map( hex.control.trigger.MockCommandClassWithParameters )
	public function say( 
							@Name( 'text' ) 								text 		: String, 
																			sender 		: CommandTriggerTest, 
							@Ignore 										anotherText : String,
							@Type( 'hex.collection.ILocator<String,Bool>' ) locator 	: Locator<String, Bool> 
						) : Expect<String>;

	public function sum( a : Int, b : Int ) : Int 
	{ 
		return a + b;
	}
}