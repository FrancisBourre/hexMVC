package hex.control.trigger.mock;

import hex.collection.Locator;
import hex.control.async.Expect;
import hex.control.async.Nothing;
import hex.control.trigger.CommandTriggerTest;

/**
 * @author Francis Bourre
 */
interface IMockController
{
	function print() : Expect<Nothing>;
	function say( text : String, sender : CommandTriggerTest, anotherText : String, locator : Locator<String, Bool> ) : Expect<String>;
	function sum( a : Int, b : Int ) : Int ;
}