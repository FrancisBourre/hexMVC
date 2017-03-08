package hex.control.trigger;

import hex.collection.Locator;
import hex.control.async.IAsyncCallback;
import hex.control.async.Nothing;
import hex.control.trigger.CommandTriggerTest;

/**
 * @author Francis Bourre
 */
interface IMockController
{
	function print() : IAsyncCallback<Nothing>;
	function say( text : String, sender : CommandTriggerTest, anotherText : String, locator : Locator<String, Bool> ) : IAsyncCallback<String>;
	function sum( a : Int, b : Int ) : Int ;
}