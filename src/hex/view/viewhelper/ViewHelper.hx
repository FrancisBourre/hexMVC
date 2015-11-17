package hex.view.viewhelper;

import hex.event.LightweightClosureDispatcher;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
class ViewHelper implements IViewHelper
{
	private var _ed 		: LightweightClosureDispatcher<ViewHelperEvent>;
	private var _owner 		: IModule;
	private var _view 		: Dynamic;
	private var _visible 	: Bool;
	
	public function new ()
	{
		this._ed = new LightweightClosureDispatcher<ViewHelperEvent>();
	}
	
	public var view( get, set ) : Dynamic;
	public function get_view() : Dynamic 
	{
		return this._view;
	}
	
	public function set_view( view : Dynamic ) : Dynamic 
	{
		this._view = view;
		return this._visible;
	}
	
	public function getOwner() : IModule
	{
		return this._owner;
	}
	
	public function setOwner( owner : IModule ) : Void 
	{
		this._owner = owner;
	}
	
	public function show() : Void 
	{
		this.visible = true;
	}
	
	public function hide() : Void 
	{
		this.visible = false;
	}
	
	public var visible( get, set ) : Bool;
	public function get_visible() : Bool 
	{
		return this._visible;
	}
	
	public function set_visible( visible : Bool ) : Bool 
	{
		this._visible = visible;
		return this._visible;
	}
	
	public function release() : Void 
	{
		this._ed.dispatchEvent( new ViewHelperEvent( ViewHelperEvent.RELEASE, this ) );
		this._view = null;
		this._ed.removeAllListeners();
	}
	
	public function addEventListener( eventType : String, callback : ViewHelperEvent->Void ) : Void 
	{
		this._ed.addEventListener( eventType, callback );
	}
	
	public function removeEventListener( eventType : String, callback : ViewHelperEvent->Void ) : Void 
	{
		this._ed.removeEventListener( eventType, callback );
	}
}