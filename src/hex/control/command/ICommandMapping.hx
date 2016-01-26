package hex.control.command;

import hex.control.async.AsyncHandler;
import hex.control.command.ICommand;
import hex.control.payload.ExecutionPayload;
import hex.di.IBasicInjector;
import hex.di.IContextOwner;

/**
 * ...
 * @author Francis Bourre
 */
interface ICommandMapping
{
    /**
     * The concrete Command Class for this mapping
     */
    function getCommandClass() : Class<ICommand>;

    /**
     * Returns true if mapping has guard
     */
    var hasGuard( get, null ) : Bool;

    /**
     * A list of Guards to query before execution
     */
    function getGuards() : Array<Dynamic>;

    /**
     * A list of Guards to query before execution
     */
    function withGuards( guards : Array<Dynamic> ) : ICommandMapping;

    /**
     * Unmaps a Command after a successful execution
     */
	var isFiredOnce( get, null ) : Bool;

    /**
     * Unmaps a Command after a successful execution
     */
    function once() : ICommandMapping;
	
	/**
     * A list of payloads to be injected during execution
     */
	var hasPayload( get, null ) : Bool;

    /**
     * A list of payloads to be injected during execution
     */
    function getPayloads() : Array<ExecutionPayload>;

    /**
     * A list of payloads to be injected during execution
     */
    function withPayloads( payloads : Array<ExecutionPayload> ) : ICommandMapping;

    /**
     * A list of complete callbacks
     */
    function getCompleteHandlers() : Array<AsyncHandler>;

    /**
     * Returns true if mapping has complete callbacks
     */
	var hasCompleteHandler( get, null ) : Bool;

    /**
     * A list of complete callbacks
     */
    function withCompleteHandlers( handler : AsyncHandler ) : ICommandMapping;

    /**
     * A list of fail callbacks
     */
    function getFailHandlers() : Array<AsyncHandler>;

    /**
     * Returns true if mapping has fail callbacks
     */
	var hasFailHandler( get, null ) : Bool;

    /**
     * A list of fail callbacks
     */
    function withFailHandlers( handler : AsyncHandler ) : ICommandMapping;

    /**
     * A list of cancel callbacks
     */
    function getCancelHandlers() : Array<AsyncHandler>;

    /**
     * Returns true if mapping has cancel callbacks
     */
	var hasCancelHandler( get, null ) : Bool;

    /**
     * A list of cancel callbacks
     */
    function withCancelHandlers( handler : AsyncHandler ) : ICommandMapping;
	
	
	function setContextOwner( contextOwner : IContextOwner ) : Void;
	
	function getContextOwner() : IContextOwner;
	
	/**
     * A list of mapping results
     */
	var hasMappingResult( get, null ) : Bool;

    /**
     * A list of mapping results
     */
	function withMappingResults( mappingResults : Array<ICommandMapping> ) : ICommandMapping;
	
	/**
     * A list of payloads taken from mapping results
     */
	function getPayloadResult() : Array<ExecutionPayload>;
	
	/**
     * Last command executed from this mapping
     */
	function setLastCommandInstance( command : ICommand ) : Void;
}
