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
    function hasGuard() : Bool;

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
    function isFiredOnce() : Bool;

    /**
     * Unmaps a Command after a successful execution
     */
    function once() : ICommandMapping;

    /**
     * A list of payloads to be injected during execution
     */
    function getPayloads() : Array<ExecutionPayload>;

    /**
     * Returns true if mapping has payload
     */
    function hasPayload() : Bool;

    /**
     * A list of payloads to be injected during execution
     */
    function withPayloads( payloads : Array<ExecutionPayload> ) : ICommandMapping;

    /**
     * A list of complete callbacks
     */
    function getCompleteListeners() : Array<AsyncCommandEvent->Void>;

    /**
     * Returns true if mapping has complete callbacks
     */
    function hasCompleteListeners() : Bool;

    /**
     * A list of complete callbacks
     */
    function withCompleteListeners( listeners : Array<AsyncCommandEvent->Void> ) : ICommandMapping;

    /**
     * A list of fail callbacks
     */
    function getFailListeners() : Array<AsyncCommandEvent->Void>;

    /**
     * Returns true if mapping has fail callbacks
     */
    function hasFailListeners() : Bool;

    /**
     * A list of fail callbacks
     */
    function withFailListeners( listeners : Array<AsyncCommandEvent->Void> ) : ICommandMapping;

    /**
     * A list of cancel callbacks
     */
    function getCancelListeners() : Array<AsyncCommandEvent->Void>;

    /**
     * Returns true if mapping has cancel callbacks
     */
    function hasCancelListeners() : Bool;

    /**
     * A list of cancel callbacks
     */
    function withCancelListeners( listeners : Array<AsyncCommandEvent->Void> ) : ICommandMapping;

    /**
     * A list of mapping results
     */
    //function withMappingResults( results : Array<Dynamic> ) : ICommandMapping;
}
