package hex.control.async;

import hex.event.BasicEvent;

/**
 * ...
 * @author Francis Bourre
 */
interface IAsyncCommandListener
{
    function onAsyncCommandComplete( e : BasicEvent ) : Void;

    function onAsyncCommandFail( e : BasicEvent ) : Void;

    function onAsyncCommandCancel( e : BasicEvent ) : Void;
}
