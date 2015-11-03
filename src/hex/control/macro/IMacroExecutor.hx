package hex.control.macro;

import hex.control.async.IAsyncCommand;
import hex.control.async.IAsyncCommandListener;
import hex.control.command.ICommand;
import hex.control.command.ICommandMapping;
import hex.event.IEvent;

/**
 * @author Francis Bourre
 */
interface IMacroExecutor 
{
	function add( commandClass : Class<ICommand> ) : ICommandMapping;
	
	function executeNextCommand( ?e : IEvent ) : ICommand;
	
	var hasNextCommandMapping( get, null ) : Bool;
	
	function setAsyncCommandListener( listener : IAsyncCommandListener ) : Void;
	
	function asyncCommandCalled( asyncCommand : IAsyncCommand ) : Void;
	
	var hasRunEveryCommand( get, null ) : Bool;

	var subCommandIndex( get, null ) : Int;

	function addMapping( mapping : ICommandMapping ) : ICommandMapping;
}