package hex.control.command;

import hex.control.payload.ExecutionPayload;
import hex.log.ILogger;
import hex.module.IContextModule;

/**
 * ...
 * @author Francis Bourre
 */
interface ICommand
{
	function execute() : Void;

    function getResult() : Array<Dynamic>;
	
	function getReturnedExecutionPayload() : Array<ExecutionPayload>;

    function getLogger() : ILogger;
	
    function getOwner() : IContextModule;

    function setOwner( owner : IContextModule ) : Void;
}
