package hex.view.viewhelper;

import hex.event.BasicEvent;

/**
 * ...
 * @author Francis Bourre
 */
class MainViewHelperManagerEvent extends BasicEvent
{
	static public inline var VIEW_HELPER_MANAGER_CREATION 	: String = "onViewHelperManagerCreation";
	static public inline var VIEW_HELPER_MANAGER_RELEASE 	: String = "onViewHelperManagerRelease";
	
	private var _viewHelperManager : ViewHelperManager;
	
	public function new ( eventType : String, target : Dynamic, viewHelperManager : ViewHelperManager )
	{
		super( eventType, target );
		
		this._viewHelperManager = viewHelperManager;
	}
	
	public function getviewHelperManager() : ViewHelperManager
	{
		return this._viewHelperManager;
	}
}