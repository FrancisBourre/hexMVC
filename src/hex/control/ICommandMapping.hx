package hex.control;

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
    function getCompleteHandlers() : Array<AsyncCommandEvent->Void>;

    /**
     * Returns true if mapping has complete callbacks
     */
	var hasCompleteHandler( get, null ) : Bool;

    /**
     * A list of complete callbacks
     */
    function withCompleteHandlers( handlers : Array<AsyncCommandEvent->Void> ) : ICommandMapping;

    /**
     * A list of fail callbacks
     */
    function getFailHandlers() : Array<AsyncCommandEvent->Void>;

    /**
     * Returns true if mapping has fail callbacks
     */
	var hasFailHandler( get, null ) : Bool;

    /**
     * A list of fail callbacks
     */
    function withFailHandlers( listeners : Array<AsyncCommandEvent->Void> ) : ICommandMapping;

    /**
     * A list of cancel callbacks
     */
    function getCancelHandlers() : Array<AsyncCommandEvent->Void>;

    /**
     * Returns true if mapping has cancel callbacks
     */
	var hasCancelHandler( get, null ) : Bool;

    /**
     * A list of cancel callbacks
     */
    function withCancelHandlers( listeners : Array<AsyncCommandEvent->Void> ) : ICommandMapping;

    /**
     * A list of mapping results
     */
    //function withMappingResults( results : Array<Dynamic> ) : ICommandMapping;
}
