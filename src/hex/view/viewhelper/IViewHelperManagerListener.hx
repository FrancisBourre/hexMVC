package hex.view.viewhelper;

/**
 * @author Francis Bourre
 */
interface IViewHelperManagerListener 
{
	function onViewHelperCreation( event : ViewHelperManagerEvent ) : Void;
	
	function onViewHelperRelease( event : ViewHelperManagerEvent ) : Void;
}