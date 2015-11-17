package hex.view.viewhelper;

import hex.event.BasicEvent;

/**
 * ...
 * @author Francis Bourre
 */
class ViewHelperManagerEvent extends BasicEvent
{
	static public inline var VIEW_HELPER_CREATION 	: String = "onViewHelperCreation";
	static public inline var VIEW_HELPER_RELEASE 	: String = "onViewHelperRelease";
	
	private var _viewHelper : IViewHelper;
	
	public function new( eventType : String, target : ViewHelperManager, viewHelper : IViewHelper )
	{
		super( eventType, target );
		
		this._viewHelper = viewHelper;
	}
	
	public function getViewHelperManager() : ViewHelperManager
	{
		return cast this.target;
	}
	
	public function getViewHelper() : IViewHelper
	{
		return this._viewHelper;
	}
}