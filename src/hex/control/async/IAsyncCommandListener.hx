package hex.control.async;

/**
 * ...
 * @author Francis Bourre
 */
interface IAsyncCommandListener
{
    function onAsyncCommandComplete( command : AsyncCommand ) : Void;

    function onAsyncCommandFail( command : AsyncCommand ) : Void;

    function onAsyncCommandCancel( command : AsyncCommand ) : Void;
}
