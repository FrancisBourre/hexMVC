package hex.view.viewhelper;

import hex.event.LightweightClosureDispatcher;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
class ViewHelper implements IViewHelper
{
	private var _ed 				: LightweightClosureDispatcher<ViewHelperEvent>;
	private var _owner 				: IModule;
	private var _view 				: IView;
	private var _isVisible 			: Bool;
	
	private var _isPreInitialized 	: Bool = false;
		
	
	public function new ()
	{
		this._ed = new LightweightClosureDispatcher<ViewHelperEvent>();
	}
	
	private function _preInitialize() : Void
	{
		
	}

	private function _initialize() : Void
	{

	}
	
	private function _release() : Void
	{

	}
	
	public var view( get, set ) : IView;
	public function get_view() : IView 
	{
		return this._view;
	}
	
	public function set_view( view : IView ) : IView 
	{
		if ( !this._isPreInitialized )
		{
			this._preInitialize();
		}

		if ( this.view != null || view == null )
		{
			this._ed.dispatchEvent( new ViewHelperEvent( ViewHelperEvent.REMOVE_VIEW, this, this._view ) );
		}
			
		this._view = view;
		
		if ( view != null )
		{
			this._ed.dispatchEvent( new ViewHelperEvent( ViewHelperEvent.ATTACH_VIEW, this, this._view ) );

			if ( view.visible )
			{
				view.visible = this._isVisible;
			}
			else
			{
				this._isVisible = false;
			}
			
			//TODO: figure out when we should fire it. now it's automatic - grosmar
			this._fireInitialisation();
		}
		
		return this._view;
	}
	
	private function _fireInitialisation() : Void
	{
		this._initialize();
		this._ed.dispatchEvent( new ViewHelperEvent( ViewHelperEvent.INIT, this ) );
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
		if ( !this._isVisible )
		{
			this.visible = true;
			if ( this._view != null )
			{
				this._view.visible = true;
			}
		}
	}
	
	public function hide() : Void 
	{
		if ( this._isVisible )
		{
			this.visible = false;
			if ( this._view != null )
			{
				this._view.visible = false;
			}
		}
	}
	
	public var visible( get, set ) : Bool;
	public function get_visible() : Bool 
	{
		return this._isVisible;
	}
	
	public function set_visible( visible : Bool ) : Bool 
	{
		if ( visible )
		{
			show();
		}
		else
		{
			hide();
		}

		return this._isVisible;
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