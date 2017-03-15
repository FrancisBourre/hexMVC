package hex.control.command;

import hex.control.payload.ExecutionPayload;
import hex.log.ILogger;
import hex.module.IModule;

/**
 * @author Francis Bourre
 */
typedef CommandDef<T> =
{
	function execute() : Void;

    function getResult() : T;
	
	function getReturnedExecutionPayload() : Array<ExecutionPayload>;

    function getLogger() : ILogger;
	
    function getOwner() : IModule;

    function setOwner( owner : IModule ) : Void;	
}