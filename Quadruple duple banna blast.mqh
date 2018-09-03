//+------------------------------------------------------------------+
//|                                              QuadBananaBlast.mqh |
//|                                                    Chris Scarola |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Chris Scarola"
#property link      "https://www.mql5.com"
//+------------------------------------------------------------------+
//| Includes                                                         |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
#include <Layouts\Box.mqh>
#include <Controls\Dialog.mqh>
#include <Controls\Label.mqh>
#include <Controls\Button.mqh> 
#include <Indicators\Trend.mqh>
#include <Indicators\Oscilators.mqh>
#include <SwingAndTrend.mqh>
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
//Sets sizes for each control used, could also be set individually
#define CONTROL_WIDTH  (100)
#define CONTROL_HEIGHT (20)
enum ENUM_TOGGLE
{
	ON,
	OFF
};
class CQuadBananaBlast : public CAppDialog
{
	private:    		//private class members
		CBox			m_main;		//the main box to store all other boxes		
		CBox			m_cv_row;	//the cv row section
		CLabel		    m_cv_label;
		CLabel		    m_cv_edit;		
		CBox			m_twr_row;	//tide wave ripple row
		CLabel			m_twr_label;
		CLabel		    m_twr_edit;		
		CBox			m_force_row;	//force row
		CLabel			m_force_label;
		CLabel			m_force_edit;
		CBox			m_impulse_row; 	//impulse row
		CLabel			m_impulse_label;
		CLabel			m_impulse_edit;		
		CBox			m_trend_row; 	//trend row
		CLabel			m_trend_label;
		CLabel 			m_trend_edit;
		CBox			m_resist_row; 	//resist row
		CLabel			m_resist_label;
		CEdit		   	m_resist_edit;
		CBox			m_price_row; 	//price row
		CLabel			m_price_label;
		CEdit 			m_price_edit;
		CBox		   	m_support_row; 	//support row
		CLabel			m_support_label;
		CEdit		   	m_support_edit;
		CBox	   		m_risk_row;		//risk row
		CLabel			m_risk_label;
		CLabel			m_risk_edit;
		
		//buttons
		CBox	  		m_buttonbuy_row;	//buy button row
		CButton	   		m_buy_button;		//contains buy button, next order button, straddle high field
		bool			m_buy_lock;			//buy lock used to lock/unlock the buy button
		CButton			m_next_button;
		ENUM_TOGGLE		m_next_toggle;
		CEdit		   	m_straddlehigh_edit;
		CBox			m_buttonsell_row;	//sell button row
		CButton			m_sell_button;		//contains sell button, straddle button, straddle low field
		bool			m_sell_lock;		//sell lock used to lock/unlock the sell button
		CButton			m_straddle_button;
		bool			m_straddle_lock;	//straddle lock, locks straddle on until opposite orders cancelled
		ENUM_TOGGLE		m_straddle_toggle;
		CEdit		   	m_straddlelow_edit;
		CBox		   	m_buttonclose_row;	//close button row
		CButton			m_ts_button;		//contains Trailing stop button, close button
		ENUM_TOGGLE		m_ts_toggle;
		CButton			m_close_button;
		
		//math functions/members
		CiOsMA			m_tide_macd;		//TWR section with colored strings
		CiMA			m_tide_ema;			//used to return to the label for TWR
		CiOsMA			m_wave_macd;		//also used with impulse
		CiMA			m_wave_ema;
		CiOsMA			m_ripple_macd;
		CiMA			m_ripple_ema;
		string			m_red;
		string			m_blue;
		string			m_green;
		CiForce        	m_force;          	//force index with wave timeframe
		bool 			ForceActivated;		//is force triggered
		
		//Trade and order variables
		MqlTick        	tick;             		//tick information	
		CiATR			m_wave_ATR;				//ATR using ripple timeframe
		CiATR           m_ripple_ATR;           //ATR used for the straddle pending orders
		double			m_stopATR;				//ATR used for stops
		double          m_straddleATR;          //ATR used in straddles
		double         	m_lotUnits;       		//holds the volume to buy/sell
		double          m_straddleUnit;         //units for straddles
		CTrade			trade;					//THE trade class to move positions
		int 			m_EA_Magic;		  		//Random number for EA identity
		double			m_previousBuyPrice;		//Hold previous price paid for a buy order
		double			m_previousSellPrice;	//Hold the sell price paid
		bool			m_buyOpened;			//tells if a buy is opened or not
		bool			m_sellOpened;			//tells if sell opened
		ulong			m_sells_pending[3];		//store the tickets of pending orders
		ulong			m_buys_pending[3];
		
		//SwingPoints and Trend storage
		CSwingPoint		RecentSPH;		//holds the most recent SP
		CSwingPoint		RecentSPL;		
		CSwingPoint		Swing[10];		//holds all the swing points
		
		CTrend			Trend;			//defines a trend
		
	public:				//public class members and functions
						CQuadBananaBlast(){}						//constructor
						~CQuadBananaBlast(){DeleteArrowObjects();}	//destructor
		virtual bool	Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2, ENUM_TIMEFRAMES tidetime, ENUM_TIMEFRAMES wavetime, ENUM_TIMEFRAMES rippletime);
		virtual bool	OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
		void			RefreshTick();
		void			RefreshBar();
		void			OnTransaction(ENUM_DEAL_TYPE type);
		
	private:			//private class functions
		//build the boxes/rows
		bool	        CreateMain(const long chart, const string name, const int subwin);
		bool 			CreateCVRow(const long chart, const string name, const int subwin);
		bool 			CreateTWRRow(const long chart, const string name, const int subwin);
		bool	        CreateForceRow(const long chart, const string name, const int subwin);
		bool	        CreateImpulseRow(const long chart, const string name, const int subwin);
		bool 	        CreateTrendRow(const long chart, const string name, const int subwin);
		bool	        CreateResistRow(const long chart, const string name, const int subwin);
		bool	        CreatePriceRow(const long chart, const string name, const int subwin);		
		bool	        CreateSupportRow(const long chart, const string name, const int subwin);
		bool	        CreateRiskRow(const long chart, const string name, const int subwin);
		//create buttons
		bool	        CreateButtonBuyRow(const long chart, const string name, const int subwin);
		bool	        CreateButtonSellRow(const long chart, const string name, const int subwin);
		bool	        CreateButtonCloseRow(const long chart, const string name, const int subwin);
		//Initiation
		bool	        Init(ENUM_TIMEFRAMES tidetime, ENUM_TIMEFRAMES wavetime, ENUM_TIMEFRAMES rippletime);
		//button operation functions
		void			ResetButtons();
		void			OnClickBuyButton();
		void			OnClickNextButton();
		void			OnClickSellButton();
		void			OnClickStraddleButton();
		void			OnClickTSButton();
		void			OnClickCloseButton();
		//Order Operations
		void			ClosePosition();
		void           	PlaceBuyOrder();
		void           	PlaceSellOrder();
		void           	MoneyMGMT();
		void           	PositionMGMT();
		void			AdjustStops();
		void			CheckPosition();		
		void			PlaceStraddle();
		void			DeletePendingBuyOrders();
		void			DeletePendingSellOrders();
		//SwingPoint functions
		void           	UpdateSwingPoints(int lookback);
		void			DeleteSwingPoints();
		void           	AddToSwingArray(CSwingPoint &sp);
		void			DrawSwingPoints();
		//refresh functions
		void	       	RefreshTripleImpulseLogic();
		void           	RefreshCurrentPrice();
		void           	RefreshStraddle();
		void           	RefreshRRRatio();
		void			RefreshTrend();
};

//+------------------------------------------------------------------+
//|  event handling                                                  |
//+------------------------------------------------------------------+
EVENT_MAP_BEGIN(CQuadBananaBlast) //looks for events inside this class
	ON_EVENT(ON_CLICK,m_buy_button,OnClickBuyButton) //looks for a click, looks for buy button, runs a buy button function
	ON_EVENT(ON_CLICK,m_next_button,OnClickNextButton) //click, next button, next button function
	ON_EVENT(ON_CLICK,m_sell_button,OnClickSellButton) //sell buttons
	ON_EVENT(ON_CLICK,m_straddle_button,OnClickStraddleButton) //straddle blah
	ON_EVENT(ON_CLICK,m_ts_button,OnClickTSButton)
	ON_EVENT(ON_CLICK,m_close_button,OnClickCloseButton)
EVENT_MAP_END(CAppDialog) //stops looking for events

//+------------------------------------------------------------------+
//|   public functions                                               |
//+------------------------------------------------------------------+
bool CQuadBananaBlast::Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2, ENUM_TIMEFRAMES tidetime, ENUM_TIMEFRAMES wavetime, ENUM_TIMEFRAMES rippletime)
{
	//create the whole panel
	if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))
		return false;
	
	//create the CBox containers in order
	if(!CreateMain(chart,name,subwin)) return false;
	if(!CreateCVRow(chart,name,subwin)) return false;
	if(!CreateTWRRow(chart,name,subwin)) return false;
	if(!CreateForceRow(chart,name,subwin)) return false;
	if(!CreateImpulseRow(chart,name,subwin)) return false;
    if(!CreateTrendRow(chart,name,subwin)) return false;
    if(!CreateResistRow(chart,name,subwin)) return false;
    if(!CreatePriceRow(chart,name,subwin)) return false;
	if(!CreateSupportRow(chart,name,subwin)) return false;
	if(!CreateRiskRow(chart,name,subwin)) return false;
		//create button rows
	if(!CreateButtonBuyRow(chart,name,subwin)) return false;
	if(!CreateButtonSellRow(chart,name,subwin)) return false;
	if(!CreateButtonCloseRow(chart,name,subwin)) return false;
	
	//Add the rows into the main CBox container
	if(!m_main.Add(m_cv_row)) return false;
	if(!m_main.Add(m_twr_row)) return false;
	if(!m_main.Add(m_force_row)) return false;
	if(!m_main.Add(m_impulse_row)) return false;
	if(!m_main.Add(m_trend_row)) return false;
	if(!m_main.Add(m_resist_row)) return false;
	if(!m_main.Add(m_price_row)) return false;
	if(!m_main.Add(m_support_row)) return false;
	if(!m_main.Add(m_risk_row)) return false;
	//add next row...
		//add button rows
	if(!m_main.Add(m_buttonbuy_row)) return false;
	if(!m_main.Add(m_buttonsell_row)) return false;
	if(!m_main.Add(m_buttonclose_row)) return false;
	
	//render the main CBox container and its children recursively
	if(!m_main.Pack()) return false;
	
	//add main as the only child of the whole panel area
	if(!Add(m_main)) return false;
	
	//now that box is built, initiate the math section
	if(!Init(tidetime,wavetime,rippletime)) return false;
	
	return true;
}
void CQuadBananaBlast::RefreshTick()
{
	RefreshCurrentPrice();
	RefreshStraddle();
	RefreshRRRatio();
	PositionMGMT();
}
void CQuadBananaBlast::RefreshBar()
{
	MoneyMGMT();
	RefreshTrend();
	RefreshTripleImpulseLogic();
}
void CQuadBananaBlast::OnTransaction(ENUM_DEAL_TYPE type)
{
	if(!m_straddle_lock) return; 		 //if no straddle, no reason to use function
	if(type == DEAL_TYPE_BUY)
	{
		DeletePendingSellOrders();		//if the deal that is set is a buy, cancel the sell pending orders
	}
	else if(type == DEAL_TYPE_SELL)
	{
		DeletePendingBuyOrders();
	}
	ResetButtons();
}
//+------------------------------------------------------------------+
//|    protected functions                                           |
//+------------------------------------------------------------------+
//--- panels and buttons
bool CQuadBananaBlast::CreateMain(const long chart, const string name, const int subwin)
{
	//Create main CBox container
	if(!m_main.Create(chart,name+"main",subwin,0,0,CDialog::ClientAreaWidth(),CDialog::ClientAreaHeight()))
		return false;
	
	//apply vertical layout
	m_main.LayoutStyle(LAYOUT_STYLE_VERTICAL);
	
	//set padding to 10 px on all sides
	m_main.Padding(2);
	
	return true;
}
bool CQuadBananaBlast::CreateCVRow(const long chart, const string name, const int subwin)
{
	//create the rox to hold the label and edit
	if(!m_cv_row.Create(chart,name+"cv_row",subwin,0,0,CDialog::ClientAreaWidth(),CONTROL_HEIGHT))
		return false;
	m_cv_row.HorizontalAlign(HORIZONTAL_ALIGN_LEFT);
	//create the label
	if(!m_cv_label.Create(chart,name+"cv_label",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
		return false;
	m_cv_label.Text("CV Analysis");
	
	//create edit control
	if(!m_cv_edit.Create(chart,name+"cv_edit",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
		return false;
	m_cv_edit.Text("0 / 0"); //Needs a variable that will hold the CV values.
	//This should have both the buy and sell half, using (buyVar + " / " + sellVar) as the output 
	//String that cannot be edited
		
	//add the controls into the row container
	if(!m_cv_row.Add(m_cv_label)) return false;
	if(!m_cv_row.Add(m_cv_edit)) return false;
	
	return true;	
}
bool CQuadBananaBlast::CreateTWRRow(const long chart, const string name, const int subwin)
{
	//create the row to hold tide wave ripple info
	if(!m_twr_row.Create(chart,name+"twr_row",subwin,0,0,CDialog::ClientAreaWidth(),CONTROL_HEIGHT))
		return false;
	m_twr_row.HorizontalAlign(HORIZONTAL_ALIGN_LEFT);
	
	//create the label
	if(!m_twr_label.Create(chart,name+"twr_label",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
		return false;
	m_twr_label.Text("T/W/R");
	
	//create edit field
	if(!m_twr_edit.Create(chart,name+"twr_edit",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
		return false;
	m_twr_edit.Text("Red / Red / Red"); //needs a variable to store each color
	
	//add the controls to the row
	if(!m_twr_row.Add(m_twr_label)) return false;
	if(!m_twr_row.Add(m_twr_edit)) return false;
	
	return true;
}
bool CQuadBananaBlast::CreateForceRow(const long chart, const string name, const int subwin)
{
	if(!m_force_row.Create(chart,name+"force_row",subwin,0,0,CDialog::ClientAreaWidth(),CONTROL_HEIGHT))
		return false;
	m_force_row.HorizontalAlign(HORIZONTAL_ALIGN_LEFT);
	if(!m_force_label.Create(chart,name+"force_label",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
		return false;
	m_force_label.Text("TS Force");
	if(!m_force_edit.Create(chart,name+"force_edit",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
		return false;
	m_force_edit.Text("Off");
	
	if(!m_force_row.Add(m_force_label)) return false;
	if(!m_force_row.Add(m_force_edit)) return false;
	
	return true;	
}
bool CQuadBananaBlast::CreateImpulseRow(const long chart, const string name, const int subwin)
{
	if(!m_impulse_row.Create(chart,name+"impulse_row",subwin,0,0,CDialog::ClientAreaWidth(),CONTROL_HEIGHT))
		return false;
	m_impulse_row.HorizontalAlign(HORIZONTAL_ALIGN_LEFT);
	if(!m_impulse_label.Create(chart,name+"impulse_label",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
		return false;
	m_impulse_label.Text("Impulse");
	if(!m_impulse_edit.Create(chart,name+"impulse_edit",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
		return false;
	m_impulse_edit.Text("Off");
	
	if(!m_impulse_row.Add(m_impulse_label)) return false;
	if(!m_impulse_row.Add(m_impulse_edit)) return false;
	
	return true;
}
bool CQuadBananaBlast::CreateTrendRow(const long chart, const string name, const int subwin)
{
	if(!m_trend_row.Create(chart,name+"trend_row",subwin,0,0,CDialog::ClientAreaWidth(),CONTROL_HEIGHT))
		return false;
	m_trend_row.HorizontalAlign(HORIZONTAL_ALIGN_LEFT);
	if(!m_trend_label.Create(chart,name+"trend_label",subwin,0,0,CONTROL_WIDTH*.8,CONTROL_HEIGHT))
		return false;
	m_trend_label.Text("Trend");
	if(!m_trend_edit.Create(chart,name+"trend_edit",subwin,0,0,CONTROL_WIDTH*1.85,CONTROL_HEIGHT))
		return false;
	m_trend_edit.Text("SUSPECT UPTREND");
	
	if(!m_trend_row.Add(m_trend_label)) return false;
	if(!m_trend_row.Add(m_trend_edit)) return false;
	
	return true;
}
bool CQuadBananaBlast::CreateResistRow(const long chart, const string name, const int subwin)
{
	if(!m_resist_row.Create(chart,name+"resist_row",subwin,0,0,CDialog::ClientAreaWidth(),CONTROL_HEIGHT))
		return false;
	m_resist_row.HorizontalAlign(HORIZONTAL_ALIGN_LEFT);
	if(!m_resist_label.Create(chart,name+"resist_label",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
		return false;
	m_resist_label.Text("Resistance");
	if(!m_resist_edit.Create(chart,name+"resist_edit",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
		return false;
	m_resist_edit.Text("");
	
	if(!m_resist_row.Add(m_resist_label)) return false;
	if(!m_resist_row.Add(m_resist_edit)) return false;
	
	return true;
}
bool CQuadBananaBlast::CreatePriceRow(const long chart, const string name, const int subwin)
{
	if(!m_price_row.Create(chart,name+"price_row",subwin,0,0,CDialog::ClientAreaWidth(),CONTROL_HEIGHT))
		return false;
	m_price_row.HorizontalAlign(HORIZONTAL_ALIGN_LEFT);
	if(!m_price_label.Create(chart,name+"price_label",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
		return false;
	m_price_label.Text("Price");
	if(!m_price_edit.Create(chart,name+"price_edit",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
		return false;
	m_price_edit.Text("0.0000");
	m_price_edit.ReadOnly(true);
	
	if(!m_price_row.Add(m_price_label)) return false;
	if(!m_price_row.Add(m_price_edit)) return false;
	
	return true;
}
bool CQuadBananaBlast::CreateSupportRow(const long chart, const string name, const int subwin)
{
	if(!m_support_row.Create(chart,name+"support_row",subwin,0,0,CDialog::ClientAreaWidth(),CONTROL_HEIGHT))
		return false;
	m_support_row.HorizontalAlign(HORIZONTAL_ALIGN_LEFT);
	if(!m_support_label.Create(chart,name+"support_label",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
		return false;
	m_support_label.Text("Support");
	if(!m_support_edit.Create(chart,name+"support_edit",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
		return false;
	m_support_edit.Text("");
	
	if(!m_support_row.Add(m_support_label)) return false;
	if(!m_support_row.Add(m_support_edit)) return false;
	
	return true;
}
bool CQuadBananaBlast::CreateRiskRow(const long chart, const string name, const int subwin)
{
	if(!m_risk_row.Create(chart,name+"risk_row",subwin,0,0,CDialog::ClientAreaWidth(),CONTROL_HEIGHT))
		return false;
	m_risk_row.HorizontalAlign(HORIZONTAL_ALIGN_LEFT);
	if(!m_risk_label.Create(chart,name+"risk_label",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
		return false;
	m_risk_label.Text("R/R (long/short)");
	if(!m_risk_edit.Create(chart,name+"risk_edit",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
		return false;
	m_risk_edit.Text("1 / 3");
	
	if(!m_risk_row.Add(m_risk_label)) return false;
	if(!m_risk_row.Add(m_risk_edit)) return false;
	
	return true;	
}
bool CQuadBananaBlast::CreateButtonBuyRow(const long chart, const string name, const int subwin)
{
	if(!m_buttonbuy_row.Create(chart,name+"buttonbuy_row",subwin,0,0,CDialog::ClientAreaWidth(),CONTROL_HEIGHT))
		return false;
	m_buttonbuy_row.HorizontalAlign(HORIZONTAL_ALIGN_LEFT);
	if(!m_buy_button.Create(chart,name+"buy_button",subwin,0,0,CONTROL_WIDTH*.6,CONTROL_HEIGHT))
		return false;
	m_buy_button.Text("Buy");
	if(!m_next_button.Create(chart,name+"next_button",subwin,0,0,CONTROL_WIDTH*1.05,CONTROL_HEIGHT))
		return false;
	m_next_button.Text("Next Order: OFF");
	m_next_toggle = OFF;
	if(!m_straddlehigh_edit.Create(chart,name+"straddlehigh_edit",subwin,0,0,CONTROL_WIDTH*.6,CONTROL_HEIGHT))
		return false;
	m_straddlehigh_edit.Text("1.10101");
	
	if(!m_buttonbuy_row.Add(m_buy_button)) return false;
	if(!m_buttonbuy_row.Add(m_next_button)) return false;
	if(!m_buttonbuy_row.Add(m_straddlehigh_edit)) return false;
	
	return true;
}
bool CQuadBananaBlast::CreateButtonSellRow(const long chart, const string name, const int subwin)
{
	if(!m_buttonsell_row.Create(chart,name+"buttonsell_row",subwin,0,0,CDialog::ClientAreaWidth(),CONTROL_HEIGHT))
		return false;
	m_buttonsell_row.HorizontalAlign(HORIZONTAL_ALIGN_LEFT);
	if(!m_sell_button.Create(chart,name+"sell_button",subwin,0,0,CONTROL_WIDTH*.6,CONTROL_HEIGHT))
		return false;
	m_sell_button.Text("Sell");
	if(!m_straddle_button.Create(chart,name+"straddle_button",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
		return false;
	m_straddle_button.Text("Straddle: OFF");
	m_straddle_toggle = OFF;
	if(!m_straddlelow_edit.Create(chart,name+"straddlelow_edit",subwin,0,0,CONTROL_WIDTH*.6,CONTROL_HEIGHT))
		return false;
	m_straddlelow_edit.Text("1.10002");
	
	if(!m_buttonsell_row.Add(m_sell_button)) return false;
	if(!m_buttonsell_row.Add(m_straddle_button)) return false;
	if(!m_buttonsell_row.Add(m_straddlelow_edit)) return false;
	
	return true;
}
bool CQuadBananaBlast::CreateButtonCloseRow(const long chart, const string name, const int subwin)
{
	if(!m_buttonclose_row.Create(chart,name+"buttonclose_row",subwin,0,0,CDialog::ClientAreaWidth(),CONTROL_HEIGHT))
		return false;
	m_buttonclose_row.HorizontalAlign(HORIZONTAL_ALIGN_LEFT);
	if(!m_ts_button.Create(chart,name+"ts_button",subwin,0,0,115,CONTROL_HEIGHT))
		return false;
	m_ts_button.Text("Trailing Stop: OFF");
	m_ts_toggle = OFF;
	if(!m_close_button.Create(chart,name+"close_button",subwin,0,0,CONTROL_WIDTH,CONTROL_HEIGHT))
		return false;
	m_close_button.Text("Close Position");
	
	if(!m_buttonclose_row.Add(m_ts_button)) return false;
	if(!m_buttonclose_row.Add(m_close_button)) return false;
	
	return true;
}
//--- Initiations and refreshes for the boxes and buttons
bool CQuadBananaBlast::Init(ENUM_TIMEFRAMES tidetime, ENUM_TIMEFRAMES wavetime, ENUM_TIMEFRAMES rippletime)
{
	//Create the MACD and EMA for Triple Screen and impulse system
	if(!m_tide_macd.Create(_Symbol, tidetime, 12, 26, 9, PRICE_CLOSE)) return false;
	if(!m_tide_ema.Create(_Symbol, tidetime, 22, 0, MODE_EMA, PRICE_CLOSE)) return false;
	if(!m_wave_macd.Create(_Symbol, wavetime, 12, 26, 9, PRICE_CLOSE)) return false;
	if(!m_wave_ema.Create(_Symbol, wavetime, 22, 0, MODE_EMA, PRICE_CLOSE)) return false;
	if(!m_ripple_macd.Create(_Symbol, rippletime, 12, 26, 9, PRICE_CLOSE)) return false;
	if(!m_ripple_ema.Create(_Symbol, rippletime, 22, 0, MODE_EMA, PRICE_CLOSE)) return false;
	if(!m_force.Create(_Symbol, wavetime, 2, MODE_EMA, VOLUME_TICK)) return false;
	//set strings
	m_red = "Red";
	m_blue = "Blue";
	m_green = "Green";
	
	//Create the ATR indicator using various timeframes for money management
	if(!m_wave_ATR.Create(_Symbol,wavetime,20)) return false;
	if(!m_ripple_ATR.Create(_Symbol,rippletime,20)) return false;
	
	//initialize booleans to false	
	ForceActivated = false;
	m_buyOpened = false;
	m_sellOpened = false;
		
	//Set buttons to not locked
	m_buy_lock = false;
	m_sell_lock = false;
	
	//check postion for time change
	CheckPosition();
	
	//Set up the trade class
	m_EA_Magic = 91243148;
	trade.SetExpertMagicNumber(m_EA_Magic);
	trade.SetDeviationInPoints(15);
	trade.SetTypeFilling(ORDER_FILLING_IOC);
	trade.SetAsyncMode(false);
	
	//Delete arrows for time changes
	//DeleteArrowObjects();

	//pull the initial data to panels
	RefreshTick();
	RefreshBar();
	
	return true;
}
void CQuadBananaBlast::RefreshCurrentPrice()
{
	//pull tick data, save in tick
	if(!SymbolInfoTick(_Symbol,tick))
	{
		Alert("Error getting the latest price quote - error:",GetLastError(),"!");
		ResetLastError();      
	}
	//show current price
	m_price_edit.Text(DoubleToString(NormalizeDouble(tick.last,_Digits),_Digits));
	
}
void CQuadBananaBlast::RefreshRRRatio()
{
	//get the values from S/R fields
	double resistance = StringToDouble(m_resist_edit.Text());
	double support = StringToDouble(m_support_edit.Text());
	double longBottom = (tick.last - support);
	double shortBottom = (resistance - tick.last);
	//make sure the bottom will not be 0
	if (longBottom == 0.0 || shortBottom == 0.0) return;
	double longrr = NormalizeDouble((resistance - support) / longBottom,1);
	double shortrr = NormalizeDouble((resistance - support) / shortBottom,1);
	//calculate and set R/R
	m_risk_edit.Text(DoubleToString(longrr,1) + " / " + DoubleToString(shortrr,1));
}
void CQuadBananaBlast::RefreshStraddle()
{
	//set straddle prices 10 pips outside of highest and lowest of the last 3 5 min bars
	MqlRates m_rate[];
	ArraySetAsSeries(m_rate,true);
	if(CopyRates(_Symbol,PERIOD_M5,0,3,m_rate) > 0)
	{
		double recentHigh = NormalizeDouble(Highest(m_rate[0].high, m_rate[1].high, m_rate[1].high),_Digits);
		double recentLow = NormalizeDouble(Lowest(m_rate[0].low, m_rate[1].low, m_rate[2].low),_Digits);
	  	 /*  
		if(_Digits == 3)
		{
	  	    recentHigh += 0.1;
	  	    recentLow -= 0.1;
		}
		else if(_Digits == 5)
		{
			recentHigh += 0.001;
	  	    recentLow -= 0.001;
		}
		*/
		recentHigh += (2 * m_straddleATR); 
		recentLow -= (2 * m_straddleATR);
		m_straddlehigh_edit.Text(DoubleToString(recentHigh,_Digits));
		m_straddlelow_edit.Text(DoubleToString(recentLow,_Digits));  
	}
	else
	{
		Alert("Error in copying last high and low, error =",GetLastError());
		ResetLastError();
	}
}
void CQuadBananaBlast::RefreshTripleImpulseLogic()
{
	//Get the data
	m_tide_macd.Refresh();
	m_tide_ema.Refresh();
	m_wave_macd.Refresh();
	m_wave_ema.Refresh();
	m_ripple_macd.Refresh();
	m_ripple_ema.Refresh();
	m_force.Refresh();
	
	//set data into variables
	double forceMain1 = m_force.Main(1);
	double forceMain2 = m_force.Main(2);
	
	double rippleMacdMain1 = m_ripple_macd.Main(1);
	double rippleMacdMain2 = m_ripple_macd.Main(2);
	double rippleEmaMain1 = m_ripple_ema.Main(1);
	double rippleEmaMain2 = m_ripple_ema.Main(2);
	double waveMacdMain1 = m_wave_macd.Main(1);
	double waveMacdMain2 = m_wave_macd.Main(2);
	double waveEmaMain1 = m_wave_ema.Main(1);
	double waveEmaMain2 = m_wave_ema.Main(2);
	double tideMacdMain1 = m_tide_macd.Main(1);
	double tideMacdMain2 = m_tide_macd.Main(2);
	double tideEmaMain1 = m_tide_ema.Main(1);
	double tideEmaMain2 = m_tide_ema.Main(2);
	
	//check each variable for triple screen/impulse system
	bool TideGreen = ((tideMacdMain1 > tideMacdMain2) && (tideEmaMain1 > tideEmaMain2)); 
	bool TideBlue = (((tideMacdMain1 >= tideMacdMain2) && (tideEmaMain1 <= tideEmaMain2)) || ((tideMacdMain1 <= tideMacdMain2) && (tideEmaMain1 >= tideEmaMain2)));
	bool TideRed = ((tideMacdMain1 < tideMacdMain2) && (tideEmaMain1 < tideEmaMain2));
	
	bool WaveGreen = ((waveMacdMain1 > waveMacdMain2) && (waveEmaMain1 > waveEmaMain2)); 
	bool WaveBlue = (((waveMacdMain1 >= waveMacdMain2) && (waveEmaMain1 <= waveEmaMain2)) || ((waveMacdMain1 <= waveMacdMain2) && (waveEmaMain1 >= waveEmaMain2)));
	bool WaveRed = ((waveMacdMain1 < waveMacdMain2) && (waveEmaMain1 < waveEmaMain2));
	
	bool RippleGreen = ((rippleMacdMain1 > rippleMacdMain2) && (rippleEmaMain1 > rippleEmaMain2)); 
	bool RippleBlue = (((rippleMacdMain1 >= rippleMacdMain2) && (rippleEmaMain1 <= rippleEmaMain2)) || ((rippleMacdMain1 <= rippleMacdMain2) && (rippleEmaMain1 >= rippleEmaMain2)));
	bool RippleRed = ((rippleMacdMain1 < rippleMacdMain2) && (rippleEmaMain1 < rippleEmaMain2));
	
	bool ForceCrossAbove = (forceMain2 < 0) && (forceMain1 > 0);
	bool ForceCrossBelow = (forceMain2 > 0) && (forceMain1 < 0);
	
	if(!ForceActivated)
		m_force_edit.Text("Off");
		
	if(TideGreen)
	{
		if(ForceActivated)
		{
			if(ForceCrossAbove)
			{
				ForceActivated = false;
				m_force_edit.Text("BUY SIGNAL");
			}
		}
		if(forceMain1 < 0)
		{
			ForceActivated = true;
			m_force_edit.Text("Trailing entry");
		}
		if(WaveGreen)
		{
			if(RippleGreen)
			{	
				m_twr_edit.Text(m_green + " / " + m_green + " / " + m_green);
				m_impulse_edit.Text("ACTIVATED BUY");
			}				
			if(RippleBlue)
			{
				m_twr_edit.Text(m_green + " / " + m_green + " / " + m_blue);
				m_impulse_edit.Text("Off");
			}				
			if(RippleRed)
			{
				m_twr_edit.Text(m_green + " / " + m_green + " / " + m_red);
				m_impulse_edit.Text("Off");
			}
		}			
		if(WaveBlue)
		{
			if(RippleGreen)
			{
				m_twr_edit.Text(m_green + " / " + m_blue + " / " + m_green);
				m_impulse_edit.Text("Off");
			}
			if(RippleBlue)
			{
				m_twr_edit.Text(m_green + " / " + m_blue + " / " + m_blue);
				m_impulse_edit.Text("Off");
			}
			if(RippleRed)
			{
				m_twr_edit.Text(m_green + " / " + m_blue + " / " + m_red);
				m_impulse_edit.Text("Off");
			}
		}
		if(WaveRed)
		{
			if(RippleGreen)
			{
				m_twr_edit.Text(m_green + " / " + m_red + " / " + m_green);
				m_impulse_edit.Text("Off");
			}
			if(RippleBlue)
			{
				m_twr_edit.Text(m_green + " / " + m_red + " / " + m_blue);
				m_impulse_edit.Text("Off");
			}
			if(RippleRed)
			{
				m_twr_edit.Text(m_green + " / " + m_red + " / " + m_red);
				m_impulse_edit.Text("weak sell");
			}	
		}			
	}			
	if(TideBlue)
	{
		ForceActivated = false;
		m_force_edit.Text("Off");
		if(WaveGreen)
		{
			if(RippleGreen)
			{
				m_twr_edit.Text(m_blue + " / " + m_green + " / " + m_green);
				m_impulse_edit.Text("ACTIVATED BUY");
			}
			if(RippleBlue)
			{
				m_twr_edit.Text(m_blue + " / " + m_green + " / " + m_blue);
				m_impulse_edit.Text("Off");
			}
			if(RippleRed)
			{
				m_twr_edit.Text(m_blue + " / " + m_green + " / " + m_red);
				m_impulse_edit.Text("Off");
			}
		}
		if(WaveBlue)
		{
			if(RippleGreen)
			{
				m_twr_edit.Text(m_blue + " / " + m_blue + " / " + m_green);
				m_impulse_edit.Text("Off");
			}
			if(RippleBlue)
			{
				m_twr_edit.Text(m_blue + " / " + m_blue + " / " + m_blue);
				m_impulse_edit.Text("Off");
			}
			if(RippleRed)
			{
				m_twr_edit.Text(m_blue + " / " + m_blue + " / " + m_red);
				m_impulse_edit.Text("Off");
			}
		}
		if(WaveRed)
		{
			if(RippleGreen)
			{
				m_twr_edit.Text(m_blue + " / " + m_red + " / " + m_green);
				m_impulse_edit.Text("Off");
			}
			if(RippleBlue)
			{
				m_twr_edit.Text(m_blue + " / " + m_red + " / " + m_blue);
				m_impulse_edit.Text("Off");
			}
			if(RippleRed)
			{
				m_twr_edit.Text(m_blue + " / " + m_red + " / " + m_red);
				m_impulse_edit.Text("ACTIVATED SELL");
			}
		}
	}	
	if(TideRed)
	{
		if(ForceActivated)
		{
			if(ForceCrossBelow)
			{
				ForceActivated = false;
				m_force_edit.Text("SELL SIGNAL");
			}
		}
		if(forceMain1 > 0)
		{
			ForceActivated = true;
			m_force_edit.Text("Trailing entry");
		}
		if(WaveGreen)
		{
			if(RippleGreen)
			{
				m_twr_edit.Text(m_red + " / " + m_green + " / " + m_green);
				m_impulse_edit.Text("weak buy");
			}
			if(RippleBlue)
			{
				m_twr_edit.Text(m_red + " / " + m_green + " / " + m_blue);
				m_impulse_edit.Text("Off");
			}
			if(RippleRed)
			{
				m_twr_edit.Text(m_red + " / " + m_green + " / " + m_red);
				m_impulse_edit.Text("Off");
			}
		}
		if(WaveBlue)
		{
			if(RippleGreen)
			{
				m_twr_edit.Text(m_red + " / " + m_blue + " / " + m_green);
				m_impulse_edit.Text("Off");
			}
			if(RippleBlue)
			{
				m_twr_edit.Text(m_red + " / " + m_blue + " / " + m_blue);
				m_impulse_edit.Text("Off");
			}
			if(RippleRed)
			{
				m_twr_edit.Text(m_red + " / " + m_blue + " / " + m_red);
				m_impulse_edit.Text("Off");
			}
		}
		if(WaveRed)
		{
			if(RippleGreen)
			{
				m_twr_edit.Text(m_red + " / " + m_red + " / " + m_green);
				m_impulse_edit.Text("Off");
			}
			if(RippleBlue)
			{
				m_twr_edit.Text(m_red + " / " + m_red + " / " + m_blue);
				m_impulse_edit.Text("Off");
			}
			if(RippleRed)
			{
				m_twr_edit.Text(m_red + " / " + m_red + " / " + m_red);
				m_impulse_edit.Text("ACTIVATED SELL");
			}
		}
	}
}
double Highest(double a, double b, double c)
{
   double max = a;
   if(b > max) max = b;
   if(c > max) max = c;
   return max;
}
double Highest(double d[])
{
	double max = d[0];
	for(int i = 1; i < ArraySize(d); i++)
	{
		if(d[i] > max) max = d[i];
	}
	return max;
}
double Lowest(double a, double b, double c)
{
   double min = a;
   if(b < min) min = b;
   if(c < min) min = c;
   return min;
}
double Lowest(double d[])
{
	double min = d[0];
	for(int i = 1; i < ArraySize(d); i++)
	{
		if(d[i] < min) min = d[i];
	}
	return min;
}	
//+------------------------------------------------------------------+
//|   Trend and SwingPoint Functions                                 |
//+------------------------------------------------------------------+
void CQuadBananaBlast::RefreshTrend()
{
	DeleteArrowObjects();
	UpdateSwingPoints(60);
	//update the trend and support/resistance values
	m_trend_edit.Text(EnumToString(Trend.Strength()) + " " + EnumToString(Trend.Direction()));
	//m_resist_edit.Text(DoubleToString(RecentSPH.Price(),_Digits));
	//m_support_edit.Text(DoubleToString(RecentSPL.Price(),_Digits));
}
void CQuadBananaBlast::UpdateSwingPoints(int lookback)
{
	DeleteSwingPoints();
	MqlRates m_rate[];
	ArraySetAsSeries(m_rate,true);
	if(CopyRates(_Symbol,_Period,0,lookback,m_rate) <= 0)
	{
		Alert("Error getting bar data for swingpoints - ",GetLastError());
		ResetLastError();
		return;
	}
	int highCount = 6;
	int lowCount = 6;
	double hPrice = m_rate[lookback-1].high;
	long hVol = m_rate[lookback-1].tick_volume;
	datetime hTime = m_rate[lookback-1].time;
	
	double lPrice = m_rate[lookback-1].low;
	long lVol = m_rate[lookback-1].tick_volume;
	datetime lTime = m_rate[lookback-1].time;
	
	for(int i = lookback-1; i >= 0; i--)
	{
		if(m_rate[i].high <= hPrice) 
		   highCount--;
		else 
		{
			hPrice = m_rate[i].high;
			hVol = m_rate[i].tick_volume;
			hTime = m_rate[i].time;
			highCount = 6;
			Trend.CheckUpTrend(m_rate[i].high,m_rate[i].tick_volume,RecentSPH.Price(),RecentSPH.Volume());
		}
		if(m_rate[i].low >= lPrice) 
		   lowCount--;
		else
		{
			lPrice = m_rate[i].low;
			lVol = m_rate[i].tick_volume;
			lTime = m_rate[i].time;
			lowCount = 6;
			Trend.CheckDownTrend(m_rate[i].low,m_rate[i].tick_volume,RecentSPL.Price(),RecentSPL.Volume());
		}
		
		if(highCount == 0)
		{
			RecentSPH.Price(hPrice);
			RecentSPH.Volume(hVol);
			RecentSPH.Time(hTime);
			RecentSPH.Type(SWING_HIGH);
			AddToSwingArray(RecentSPH);
			
			hPrice = m_rate[i].high;
			hVol = m_rate[i].tick_volume;
			hTime = m_rate[i].time;
			highCount = 6;
		}
		if(lowCount == 0)
		{
			RecentSPL.Price(lPrice);
			RecentSPL.Volume(lVol);
			RecentSPL.Time(lTime);
			RecentSPL.Type(SWING_LOW);
			AddToSwingArray(RecentSPL);
				
			lPrice = m_rate[i].low;
			lVol = m_rate[i].tick_volume;
			lTime = m_rate[i].time;
			lowCount = 6;
		}
	}
	DrawSwingPoints();
}
void CQuadBananaBlast::DeleteSwingPoints()
{
	int size = ArraySize(Swing);
	for(int i = 0; i < size; i++) 
	{
		Swing[i].Price(0);       
		Swing[i].Volume(0);
		Swing[i].Time(0);
		Swing[i].Type(0);
	}
}
void CQuadBananaBlast::AddToSwingArray(CSwingPoint &sp)
{
	int size = ArraySize(Swing);
	for(int i = size - 1; i > 0; i--) //loop through all swingpoints
	{
		Swing[i].Price(Swing[i-1].Price());        //move all the swing points back by 1 index
		Swing[i].Volume(Swing[i-1].Volume());
		Swing[i].Time(Swing[i-1].Time());
		Swing[i].Type(Swing[i-1].Type());
		
	}
	Swing[0].Price(sp.Price());                   //set the new swingpoint to 0 slot
	Swing[0].Volume(sp.Volume());
	Swing[0].Time(sp.Time());
	Swing[0].Type(sp.Type());
}
void CQuadBananaBlast::DrawSwingPoints()
{
	int size = ArraySize(Swing);
	for(int i = 0; i < size; i++) 
	{
		Swing[i].Draw();
	}
}
void DeleteArrowObjects()
{
   ObjectsDeleteAll(0,"",0,OBJ_ARROW_UP);
   ObjectsDeleteAll(0,"",0,OBJ_ARROW_DOWN);
}
//+------------------------------------------------------------------+
//|   Button Functions                                               |
//+------------------------------------------------------------------+
void CQuadBananaBlast::ResetButtons()
{
	m_buy_button.Pressed(false);
	m_sell_button.Pressed(false);
	m_next_button.Pressed(false);
	m_straddle_button.Pressed(false);
	m_ts_button.Pressed(false);
	m_close_button.Pressed(false);
	
	if(m_buy_lock) m_buy_button.Text("Locked");
	else m_buy_button.Text("Buy");
	
	if(m_sell_lock) m_sell_button.Text("Locked");
	else m_sell_button.Text("Sell");
	
	if(m_next_toggle == OFF) m_next_button.Text("Next Order: OFF");
	else if(m_next_toggle == ON) m_next_button.Text("Next Order: ON");
	
	if(m_straddle_toggle == OFF) 
		m_straddle_button.Text("Straddle: OFF");
	else if(m_straddle_toggle == ON) 
	{
		m_straddle_button.Text("Straddle: ON");
		m_sell_button.Text("Straddle");
	}
	
	if(m_ts_toggle == OFF) m_ts_button.Text("Trailing Stop: OFF");
	else if(m_ts_toggle == ON) m_ts_button.Text("Trailing Stop: ON");
}
void CQuadBananaBlast::OnClickBuyButton()
{
	if(!m_buy_lock && m_straddle_toggle == OFF)
		PlaceBuyOrder();
	if(!m_straddle_lock && m_straddle_toggle == ON && !PositionSelect(_Symbol))
		PlaceStraddle();
	
	ResetButtons();
}
void CQuadBananaBlast::OnClickNextButton()
{
	m_next_toggle = (m_next_toggle == OFF) ? ON : OFF;
	if(m_next_toggle == ON) m_ts_toggle = OFF;
	ResetButtons();
}
void CQuadBananaBlast::OnClickSellButton()
{
	if(!m_sell_lock && m_straddle_toggle == OFF)
		PlaceSellOrder();
		
	ResetButtons();
}
void CQuadBananaBlast::OnClickStraddleButton()
{
	if(!m_straddle_lock)
	    m_straddle_toggle = (m_straddle_toggle == OFF) ? ON : OFF;
	ResetButtons();
}
void CQuadBananaBlast::OnClickTSButton()
{
	m_ts_toggle = (m_ts_toggle == OFF) ? ON : OFF;
	if(m_ts_toggle == ON) m_next_toggle = OFF;
	ResetButtons();
}
void CQuadBananaBlast::OnClickCloseButton()
{
	ClosePosition();
	
	ResetButtons();
}
//+------------------------------------------------------------------+
//|   Order Operations                                               |
//+------------------------------------------------------------------+
void CQuadBananaBlast::MoneyMGMT()
{
    //pull account equity for most updated buying power
	double acctBalance = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),2);
	//refresh the ATRs
	m_wave_ATR.Refresh();
	m_ripple_ATR.Refresh();
	//set the ATRs
	m_straddleATR = NormalizeDouble(m_ripple_ATR.Main(0),_Digits);
	m_stopATR = NormalizeDouble(m_wave_ATR.Main(0),_Digits);
	if(_Digits == 3)
	{
	    m_stopATR /=100;
	    m_straddleATR /=100;
	}
	if(m_straddleATR < 0.0001) m_straddleATR = 0.0001;  //if too small, the program will not place the order
	if(m_stopATR < 0.0001) m_stopATR = 0.0001;
	//Sets risk to 1% of account based on ATR 20 volatility and $100,000 currency bundle 
	m_lotUnits = NormalizeDouble(((0.01 * acctBalance) / (m_stopATR * 100000)),2); 
	m_straddleUnit = NormalizeDouble(((0.01 * acctBalance) / (m_straddleATR * 100000)),2);  
	if(_Digits == 3)
	{
	    m_stopATR *=100;
	    m_straddleATR *=100;
	}
}
void CQuadBananaBlast::PositionMGMT()
{
	if(m_buyOpened)
	{
	    //check if a stoploss ended the current open position, reset lock and opened variables
		if(!PositionSelect(_Symbol))
		{
			m_buyOpened = false;
			m_buy_lock = false;
			ResetButtons();
			return;
		}			
		//if price is within risk range, do not allow another position
		if(tick.ask < (m_previousBuyPrice + (2 * m_stopATR)))
		{
			m_buy_lock = true;
			
		}
		//outside of range, allow purchase
		else if(tick.ask >= (m_previousBuyPrice + (2 * m_stopATR)))
		{
			m_buy_lock = false;
			if(m_next_toggle == ON)     //if next toggle button is on, place orders automatically
				PlaceBuyOrder();
			if(m_ts_toggle == ON)       //if trailing stop is on, trail the stops
				AdjustStops();
		}
		ResetButtons();                 //reset the button after each run to check if lock is changed
	}
	if(m_sellOpened)
	{
		if(!PositionSelect(_Symbol))
		{
			m_sellOpened = false;
			m_sell_lock = false;
			ResetButtons();
			return;
		}
		if(tick.bid > (m_previousSellPrice - (2 * m_stopATR)))
		{
			m_sell_lock = true;
		}
		else if(tick.bid <= (m_previousSellPrice - (2 * m_stopATR)))
		{
			m_sell_lock = false;
			if(m_next_toggle == ON)
				PlaceSellOrder();
			if(m_ts_toggle == ON)
				AdjustStops();
		}
		ResetButtons();
	}
	else
		return;
}
void CQuadBananaBlast::AdjustStops()
{
	double stoploss = PositionGetDouble(POSITION_SL);           //get current stoploss
	PositionSelect(_Symbol);
	if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)  
		if(tick.ask >= stoploss + (3 * m_stopATR))              //if buy, and price is high enough, move the stop by 1 ATR unit
			stoploss += (m_stopATR);
	if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
		if(tick.bid <= stoploss - (3 * m_stopATR))	
			stoploss -= (m_stopATR);
	if(stoploss != PositionGetDouble(POSITION_SL))              //if the stoploss has changed, send the modify order function
		trade.PositionModify(_Symbol,stoploss,0);
	return;
}
void CQuadBananaBlast::CheckPosition()
{
	//checks if a position is open when timeframes change
	if(PositionSelect(_Symbol))
	{
		if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
		{
			m_buyOpened = true;
			m_previousBuyPrice = PositionGetDouble(POSITION_PRICE_OPEN);
			m_buy_lock = true;
		}			
		else if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
		{
			m_sellOpened = true;
			m_previousSellPrice = PositionGetDouble(POSITION_PRICE_OPEN);
			m_sell_lock = true;
		}			
	}
	ResetButtons();
	return;
}
void CQuadBananaBlast::ClosePosition()
{
	if(PositionSelect(_Symbol))
	{
		trade.SetAsyncMode(true);
		trade.PositionClose(_Symbol,-1);
		Alert("Close code: ",trade.ResultRetcode(), " - ",trade.ResultRetcodeDescription());
		trade.SetAsyncMode(false);
	}
	else
		Alert("No Position Open");
	
	if(m_straddle_lock)
	{
		DeletePendingBuyOrders();
		DeletePendingSellOrders();
	}
	else
		Alert("No Straddle in place");
	
	m_buyOpened = false;
	m_sellOpened = false;
	m_buy_lock = false;
	m_sell_lock = false;
	m_ts_toggle = OFF;
	m_next_toggle = OFF;
	m_straddle_toggle = OFF;
	ResetButtons();
}
void CQuadBananaBlast::PlaceBuyOrder()
{
	double stoploss = NormalizeDouble(tick.ask - (m_stopATR * 2),_Digits);
	bool result = trade.Buy(m_lotUnits,_Symbol,tick.ask,stoploss,0,NULL);
    uint retcode = trade.ResultRetcode();
    if(result && (retcode == 10009 || retcode == 10008))
	{
		Alert(_Symbol," buy placed with ticket #: ",trade.ResultOrder());
		m_previousBuyPrice = NormalizeDouble(trade.ResultPrice(),_Digits);
		m_buyOpened = true;
		return;
	}
	else
	{
		Alert(_Symbol," buy order failed - error: ",GetLastError()," with trade error ",retcode," - ",trade.ResultRetcodeDescription(),". Price used ",tick.ask,". Volume used: ",m_lotUnits);
		ResetLastError();
		return;
	}
}
void CQuadBananaBlast::PlaceSellOrder()
{
	double stoploss = NormalizeDouble(tick.bid + (m_stopATR * 2),_Digits);
	bool result = trade.Sell(m_lotUnits,_Symbol,tick.bid,stoploss,0,NULL);
	unit retcode = trade.ResultRetcode();
	if(result && (retcode == 10009 || retcode == 10008))
	{
		Alert(_Symbol," sell placed with ticket #: ",trade.ResultOrder());
		m_previousSellPrice = NormalizeDouble(trade.ResultPrice(),_Digits);
		m_sellOpened = true;
		return;
	}
	else
	{
		Alert(_Symbol," sell order failed - error: ",GetLastError()," with trade error ",retcode," - ",trade.ResultRetcodeDescription(),". Price used ",tick.ask,". Volume used: ",m_lotUnits);
		ResetLastError();
		return;
	}
}
void CQuadBananaBlast::PlaceStraddle()
{
	m_previousBuyPrice = StringToDouble(m_straddlehigh_edit.Text());
	m_previousSellPrice = StringToDouble(m_straddlelow_edit.Text());
	
	double highstop = NormalizeDouble(m_previousBuyPrice - (m_straddleATR * 2),_Digits);
	double lowstop = NormalizeDouble(m_previousSellPrice + (m_straddleATR * 2),_Digits);
			
	for(int i = 0; i < 3; i++)
	{
		if(trade.BuyStop(m_straddleUnit,m_previousBuyPrice,_Symbol,highstop,0,ORDER_TIME_GTC,0,"") && (trade.ResultRetcode() == 10009 || trade.ResultRetcode() == 10008))
		{
			m_buys_pending[i] = trade.ResultOrder();
			m_previousBuyPrice = NormalizeDouble(m_previousBuyPrice,_Digits) + ((m_straddleATR * 2) * (i+1));
			highstop = NormalizeDouble(m_previousBuyPrice - (m_straddleATR * 2),_Digits);
		}
		else
		{
			Alert(_Symbol," straddle buy half failed - error: ",GetLastError()," with trade error ",trade.ResultRetcode()," - ",trade.ResultRetcodeDescription(),". Price used ",m_previousBuyPrice,". Volume used: ",m_straddleUnit);
			ResetLastError();
			return;
		}
		if(trade.SellStop(m_straddleUnit,m_previousSellPrice,_Symbol,lowstop,0,ORDER_TIME_GTC,0,"") && (trade.ResultRetcode() == 10009 || trade.ResultRetcode() == 10008))
		{
			m_sells_pending[i] = trade.ResultOrder();
			m_previousSellPrice = NormalizeDouble(m_previousSellPrice,_Digits) - ((m_straddleATR * 2) * (i+1));
			lowstop = NormalizeDouble(m_previousSellPrice + (m_straddleATR * 2),_Digits);			
		}
		else
		{
			Alert(_Symbol," straddle sell half failed - error: ",GetLastError()," with trade error ",trade.ResultRetcode()," - ",trade.ResultRetcodeDescription(),". Price used ",m_previousSellPrice,". Volume used: ",m_straddleUnit);
			ResetLastError();
			return;
		}
		
	}
	m_straddle_lock = true;
}
void CQuadBananaBlast::DeletePendingBuyOrders()
{
	int size = ArraySize(m_buys_pending);
	for(int i = 0; i < size;i++)
	{
		trade.OrderDelete(m_buys_pending[i]);
		m_buys_pending[i] = 0;
	}
	m_straddle_lock = false;
	m_straddle_toggle = OFF;
}
void CQuadBananaBlast::DeletePendingSellOrders()
{
	int size =  ArraySize(m_sells_pending);
	for(int i = 0; i < size;i++)
	{
		trade.OrderDelete(m_sells_pending[i]);
		m_sells_pending[i] = 0;
	}
	m_straddle_lock = false;
	m_straddle_toggle = OFF;
}

//+------------------------------------------------------------------+
//|   Testing printouts/Alerts                                       |
//+------------------------------------------------------------------+
/*
	Alert(lookbackBars);
	
	Alert(DoubleToString(RecentSPH.Price(),_Digits) + " " + IntegerToString(RecentSPH.Volume()) + " " + TimeToString(RecentSPH.Time()) + " " + EnumToString(RecentSPH.Type()));
	Alert(DoubleToString(RecentSPL.Price(),_Digits) + " " + IntegerToString(RecentSPL.Volume()) + " " + TimeToString(RecentSPL.Time()) + " " + EnumToString(RecentSPL.Type()));
	
	for(int i = 0; i <= 3;i++)
	{
	   Alert(DoubleToString(Swing[i].Price(),_Digits) + " " + IntegerToString(Swing[i].Volume()) + " " + TimeToString(Swing[i].Time()) + " " + EnumToString(Swing[i].Type()));
	}
	for(int i = ArraySize(Swing)-1; i >= 0;i--)
	{
	   Alert(DoubleToString(Swing[i].Price(),_Digits) + " " + IntegerToString(Swing[i].Volume()) + " " + TimeToString(Swing[i].Time()) + " " + EnumToString(Swing[i].Type()));
	}
	Alert(m_previousBuyPrice);
*/
//+------------------------------------------------------------------+
//|   Triple Impulse Bananas                                         |
//+------------------------------------------------------------------+
/*
#include <Trade\Trade.mqh>
CTrade trade;
//--- Input variables
//--- EMA settings and timeframe selection
input ENUM_TIMEFRAMES Tide_Timeframe = PERIOD_M30; 	//Timeframe for the Third screen
input ENUM_TIMEFRAMES Wave_Timeframe = PERIOD_M5;  	//Timeframe for the Second screen
input ENUM_TIMEFRAMES Ripple_Timeframe = PERIOD_M1; //Timeframe for the First screen
int Tide_EMA_Period = 22;   //Third screen EMA period
int Wave_EMA_Period = 22;   //Second screen EMA perod
int Ripple_EMA_Period = 22; //First screen EMA period
//--- MACD settings for the tide and wave screens
int Tide_Fast = 12;  //Third screen Fast MACD line
int Tide_Slow = 26;  //Third screen Slow MACD line
int Tide_Signal = 9; //Third screen MACD signal line
int Wave_Fast = 12;  //Second screen Fast MACD line
int Wave_Slow = 26;  //Second screen Slow MACD line
int Wave_Signal = 9; //Second screen MACD signal line
int Ripple_Fast = 12;  //First screen MACD fast line
int Ripple_Slow = 26;  //First screen MACD slow linem
int Ripple_Signal = 9; //First screen MACD signal line
//--- Handles and Arrays
int TideEMAHandle;    //Handle for the third timeframe EMA
int WaveEMAHandle;    //Handle for the second timeframe EMA
int RippleEMAHandle;  //Handle for the first timeframe EMA
int TideMACDHandle;   //Handle to store third timeframe MACD value
int WaveMACDHandle;   //Handle to store second timeframe MACD value
int RippleMACDHandle; //Handle to store first timeframe MACD value
int ForceHandle;      //Handle to store the second screen Force Index
int ATRHandle;        //Handle to store ATR
double TideEMA[];     //Array to hold the values of Third screen EMA
double WaveEMA[];     //Array to hold the values of Second screen EMA
double RippleEMA[];   //Array to hold the values of first screen EMA
double TideMACD[];    //Array to hold the values of Third screen MACD
double WaveMACD[];    //Array to hold the values of Second screen MACD
double RippleMACD[];  //Array to hold the values of first screen MACD
double Force[];       //Array to hold the values of Second screen Force Index
double ATR[];         //Array to hold ATR values
MqlRates TideBar[];   //Array to hold value of the Tide bars
//--- Money Management parameters
input double protectPercent = 0.0;   //Percentage of profits to set aside
input double drawdownPercent = 0.06; //Maximum drawdown percent out of 1.0
input int LotSize = 1000;           //Set Lot size to trade
double Lot = 0.1;         //Default Lot size
double lotUnits;          //Lot Unit size holds volitilty adjusted volume selection
int EA_Magic = 91225048;  //Random number for EA identity
double previousUsedPrice; //Saves last price an order was placed with
double remainingBalance;  //Holds the usable balance after money is put aside to withdraw
double maxBalance;        //Stores maximum balance ever reached
double usefulBalance;     //Turtle balance to be used for trading
double saveBank;          //The profit being protected, to be withdrawn to bank later
double ProtectiveStop;    //Initial and possible trailing stop
double ProfitExit;        //Profit target if used for impulse
bool IsNewBar;               //Sets the variable to check if new bar is present
bool PositionThisBar = false;//Tells if a position is open this bar to prevent multiple entries
bool Buy_opened = false;     //variable to hold the mresult of  Buy opened position
bool Sell_opened = false;    //variable to hold the mresult of Sell opened position
bool ForceActivated = false; //Sets count to track Force Index order placement to limits orders
bool TripleScreen = false;   //Shows when using triple screen
bool ImpulseSystem = false;  //Shows when using impulse system
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- Initiate the account balance size and beginning amount to protect  
  remainingBalance = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE),2);
  saveBank = 0.0;
  maxBalance = 0.0;
//--- Do we have enough bars to work with?
   if(Bars(_Symbol,_Period) < Ripple_EMA_Period) //If total bars is less than ammount needed
     {
      Alert("We have less than ",Ripple_EMA_Period," bars, EA will now exit!");
      return(-1);
     }
//--- Get handle for the indicators
   TideEMAHandle = iMA(_Symbol,Tide_Timeframe,Tide_EMA_Period,0,MODE_EMA,PRICE_CLOSE);
   WaveEMAHandle = iMA(_Symbol,Wave_Timeframe,Wave_EMA_Period,0,MODE_EMA,PRICE_CLOSE);
   RippleEMAHandle = iMA(_Symbol,_Period,Ripple_EMA_Period,0,MODE_EMA,PRICE_CLOSE);
   TideMACDHandle = iMACD(_Symbol,Tide_Timeframe,Tide_Fast,Tide_Slow,Tide_Signal,PRICE_CLOSE);
   WaveMACDHandle = iMACD(_Symbol,Wave_Timeframe,Wave_Fast,Wave_Slow,Wave_Signal,PRICE_CLOSE);
   RippleMACDHandle = iMACD(_Symbol,_Period,Ripple_Fast,Ripple_Slow,Ripple_Signal,PRICE_CLOSE);
   
   ForceHandle = iForce(_Symbol,Wave_Timeframe,2,MODE_EMA,VOLUME_TICK);
   ATRHandle = iATR(_Symbol,_Period,20);
//--- If an indicator fails
   if(TideEMAHandle < 0 || WaveEMAHandle < 0 || RippleEMAHandle < 0 || TideMACDHandle < 0 || WaveMACDHandle < 0 || RippleMACDHandle < 0 || ForceHandle < 0 || ATRHandle < 0)
     {
      Alert("Error Creating Handle for indicator - error: ",GetLastError());
     }
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- Release the handles
   IndicatorRelease(TideEMAHandle);
   IndicatorRelease(WaveEMAHandle);
   IndicatorRelease(RippleEMAHandle);
   IndicatorRelease(TideMACDHandle);
   IndicatorRelease(WaveMACDHandle);
   IndicatorRelease(RippleMACDHandle);
   IndicatorRelease(ForceHandle);   
   IndicatorRelease(ATRHandle);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---Check for stop settings if a position is opened
   if(Buy_opened || Sell_opened) 
      CheckStops();      
//--- Checks for New bar, only if a position was opened on a bar
   CheckForNewBar();
//--- EA should only check for new trade if we have a new bar
   if(!IsNewBar)
      return;      
//--- Set the Arrays into Series, define the handles into indicator buffers
   if(!SetArraysBuffers())
      return;
//--- Money managment, protects profits and prevents massive drawdown
   if(!MoneyMGMT())
      return;
/* 
   The logic of this EA: Elder Tiple Screen using impulse system during sideways tide periods.
   Only Wave and Ripple are used when using the impulse system.

   TripleImpulseLogic();
  }
  
//--- All used functions go below the original OnTick function
void CheckForNewBar()
  {
/* We will use the static Old_Time variable to serve the bar time.
   At each OnTick execution we will check the current bar time with the saved one.
   If the bar time isn't equal to the saved time, it indicates that we have a new bar.

   static datetime Old_Time;
   datetime New_Time[1];
   //if theres a position this bar, then allow bar tracking to go to false to show it is not a new bar
   if(PositionThisBar)
      IsNewBar = false;
   
//--- Copying the last bar time to the element NewTime[0]
   int copied = CopyTime(_Symbol,_Period,0,1,New_Time);
   if(copied > 0) //ok, the data has been copied successfully
     {
      if(Old_Time == New_Time[0]) return; //exits if it is not a new bar
      IsNewBar = true; //if it isn't a first call, the new bar has appeared
      PositionThisBar = false; 
      if(MQLInfoInteger(MQL_DEBUG)) Print("We have new bar here ",New_Time[0]," old time was ",Old_Time);
      Old_Time = New_Time[0]; //saving bar time
     }
   else
     {
      Alert("Error in copying historical times data, error =",GetLastError());
      ResetLastError();
      return;
     }
  }
bool SetArraysBuffers()
  {
//--- Store the arrays as series
   ArraySetAsSeries(TideEMA,true);
   ArraySetAsSeries(WaveEMA,true);
   ArraySetAsSeries(RippleEMA,true);
   ArraySetAsSeries(TideMACD,true);
   ArraySetAsSeries(WaveMACD,true);
   ArraySetAsSeries(RippleMACD,true);
   ArraySetAsSeries(Force,true);  
   ArraySetAsSeries(ATR,true); 
   ArraySetAsSeries(TideBar,true);
//--- Copy indicators from handles into the arrays
   if(CopyBuffer(TideEMAHandle,0,0,3,TideEMA) < 0)
     {
      Alert("Error copying Tide EMA indicator into buffer - error: ",GetLastError());
      return(false);
     }
   if(CopyBuffer(WaveEMAHandle,0,0,3,WaveEMA) < 0)
     {
      Alert("Error copying Wave EMA indicator into buffer - error: ",GetLastError());
      return(false);
     }
   if(CopyBuffer(RippleEMAHandle,0,0,3,RippleEMA) < 0)
     {
      Alert("Error copying Ripple EMA indicator into buffer - error: ",GetLastError());
      return(false);
     }     
   if(CopyBuffer(TideMACDHandle,0,0,3,TideMACD) < 0)
     {
      Alert("Error copying Tide MACD indicator into buffer - error: ",GetLastError());
      return(false);
     }
   if(CopyBuffer(WaveMACDHandle,0,0,3,WaveMACD) < 0)
     {
      Alert("Error copying Wave MACD indicator into buffer - error: ",GetLastError());
      return(false);
     }
   if(CopyBuffer(RippleMACDHandle,0,0,3,RippleMACD) < 0)
     {
      Alert("Error copying Ripple MACD indicator into buffer - error: ",GetLastError());
      return(false);
      }
   if(CopyBuffer(ForceHandle,0,0,2,Force) < 0)
     {
      Alert("Error copying Force Index indicator into buffer - error: ",GetLastError());
      return(false);
     } 
   if(CopyBuffer(ATRHandle,0,0,1,ATR) < 0)
     {
      Alert("Error copying ATR indicator into buffer - error: ",GetLastError());
      return(false);
     }        
   if(CopyRates(_Symbol,Tide_Timeframe,0,2,TideBar) < 0)
     {
      Alert("Error copying Tide bars into buffer - error: ",GetLastError());
      return(false);
     } 
   return(true);
  }
 
bool MoneyMGMT()
  {
//--- If profits exist, protect them, otherwise maintain bank away from balance
   double totalBalance = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE),2);
   double balDiff = totalBalance - remainingBalance - saveBank;
   if(balDiff > 0.0) //Only protects if a profit occurs.
     {
      saveBank = NormalizeDouble((saveBank + (balDiff * protectPercent)),2); //protects a percentage of profits so the account never uses it
      remainingBalance = NormalizeDouble((totalBalance - saveBank),2);     
     }
   else
     {
      remainingBalance = NormalizeDouble((totalBalance - saveBank),2);
     }
//Turtle management section     
   if(remainingBalance > maxBalance)
      maxBalance = NormalizeDouble(remainingBalance,2);  //tracks the maximum balance reached based on where current balance is
   
   usefulBalance = NormalizeDouble((maxBalance - ((1/drawdownPercent) * (maxBalance - remainingBalance))),2); //Money used to trade is adjusted based on DrawdownPercent away from the maximum ever reached
   if(usefulBalance <= 0.00)
     {
      if(Buy_opened || Sell_opened) ClosePosition();
      Alert("Out of usable Balance. Waiting 22 minutes to reset."); 
      usefulBalance = remainingBalance; 
      Sleep(1320000);      
      return(false);         
     }
   lotUnits = NormalizeDouble(((0.01 * usefulBalance) / (ATR[0] * LotSize)),2); //Sets risk to 1% of account based on ATR 20 volatility and lot sizes   
   lotUnits = NormalizeDouble(lotUnits / (100000 / LotSize),2); //Adjusts lot buying based on lots used ex: full lot vs mini or micro lots determined by LotSize variable
//If run out of trading volume, stop trading here
   if(lotUnits <= 0.00)
     {
      if(Buy_opened || Sell_opened) ClosePosition();
      Alert("Not enough volume. Waiting 22 minutes to reset.");  
      usefulBalance = remainingBalance; 
      Sleep(1320000);         
      return(false);
     }
   return(true);
  }
  
void TripleImpulseLogic()
  {
   double currentBID = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   double currentASK = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
//--- Tide/Third screen impulse signals
   bool TideGreen = ((TideEMA[1] > TideEMA[2]) && (TideMACD[1] > TideMACD[2])); //Both EMA and MACD rising
   bool TideBlue = (((TideEMA[1] <= TideEMA[2]) && (TideMACD[1] >= TideMACD[2])) || ((TideEMA[1] >= TideEMA[2]) && (TideMACD[1] <= TideMACD[2]))); //MACD and EMA opposite
   bool TideRed = ((TideEMA[1] < TideEMA[2]) && (TideMACD[1] < TideMACD[2]));   //Both EMA and MACD falling
//--- Wave/Second screen impulse signals   
   bool WaveGreen = ((WaveEMA[1] > WaveEMA[2]) && (WaveMACD[1] > WaveMACD[2])); //Both EMA and MACD rising
   bool WaveBlue = (((WaveEMA[1] <= WaveEMA[2]) && (WaveMACD[1] >= WaveMACD[2])) || ((WaveEMA[1] >= WaveEMA[2]) && (WaveMACD[1] <= WaveMACD[2]))); //MACD and EMA opposite
   bool WaveRed = ((WaveEMA[1] < WaveEMA[2]) && (WaveMACD[1] < WaveMACD[2]));   //Both EMA and MACD falling
//--- Ripple/First screen impulse signals
   bool RippleGreen = ((RippleEMA[1] > RippleEMA[2]) && (RippleMACD[1] > RippleMACD[2])); //Both EMA and MACD rising
   bool RippleBlue = (((RippleEMA[1] <= RippleEMA[2]) && (RippleMACD[1] >= RippleMACD[2])) || ((RippleEMA[1] >= RippleEMA[2]) && (RippleMACD[1] <= RippleMACD[2]))); //MACD and EMA opposite
   bool RippleRed = ((RippleEMA[1] < RippleEMA[2]) && (RippleMACD[1] < RippleMACD[2]));   //Both EMA and MACD falling
//--- Force Index signals
   bool ForceBuy = (Force[0] < 0);   //Force add to Long position when below 0 line
   bool ForceSell = (Force[0] > 0);  //Force add to Short position when above 0 line
   bool ForceCrossAbove = ((Force[1] < 0) && ForceSell); //Resets the Force counting 
   bool ForceCrossBelow = ((Force[1] > 0) && ForceBuy);  //Resets the Force counting
   
   if(ForceCrossAbove || ForceCrossBelow)  //Deactivates Force setting to allow trading again, for the next force buy or sell
      ForceActivated = false;
   
   if(TideBlue)
     {
      if(TripleScreen)
        {
         if(Buy_opened)
           {
            if(ProtectiveStop != TideBar[1].low)
              {
               ProtectiveStop = TideBar[1].low;
              }
           }
         if(Sell_opened)
           {
            if(ProtectiveStop != TideBar[1].high)
              {
               ProtectiveStop = TideBar[1].high;   
              }
           }  
        }
      if(ImpulseSystem)
        {
         if(Buy_opened)
           {
            if(!WaveGreen || !RippleGreen)
              {
               AdjustStops();
              }
           }
         if(Sell_opened)
           {
            if(!WaveRed || !RippleRed)
              {
               AdjustStops();
              }
           }  
        }
      else if(!ImpulseSystem && !TripleScreen)
             {
              if(WaveGreen)
                {
                 if(RippleGreen)
                   {
                    if(OpenPosition(ORDER_TYPE_BUY))
                      {
                       ImpulseSystem = true;
                      }
                   }
                }
               if(WaveRed)
                 {
                  if(RippleRed)
                    {
                     if(OpenPosition(ORDER_TYPE_SELL))
                       {
                        ImpulseSystem = true;
                       }
                    }
                 } 
             }    
     }
   if(TideGreen)
     {
      if(ForceBuy && !ForceActivated && !ImpulseSystem)
        {
         if((currentASK < (RippleEMA[0] - ATR[0])) && (currentASK < WaveEMA[0]))
           {
            TrailingEntry(ORDER_TYPE_BUY);
           }
        }
      if(ImpulseSystem)
        {
         if(Buy_opened)
           {
            if(!WaveGreen || !RippleGreen)
              {
               AdjustStops();
              }
           }
        }
      else if(!ImpulseSystem && !TripleScreen)
             {
              if(WaveGreen)
                {
                 if(RippleGreen)
                   {
                    if(OpenPosition(ORDER_TYPE_BUY))
                      {
                       ImpulseSystem = true;
                      }
                   }
                }
             }
     }
   if(TideRed)
     {
      if(ForceBuy &&!ForceActivated && !ImpulseSystem)
        {
         if((currentBID > (RippleEMA[0] + ATR[0])) && (currentBID > WaveEMA[0]))
           {
            TrailingEntry(ORDER_TYPE_SELL);
           }
        }
     }
      if(ImpulseSystem)
        {
         if(Sell_opened)
           {
            if(!WaveRed || !RippleRed)
              {
               AdjustStops();
              }
           }  
        }
      else if(!ImpulseSystem && !TripleScreen)
             {
               if(WaveRed)
                 {
                  if(RippleRed)
                    {
                     if(OpenPosition(ORDER_TYPE_SELL))
                       {
                        ImpulseSystem = true;
                       }
                    }
                 } 
             }       
  }
  
void TrailingEntry(ENUM_ORDER_TYPE type)
  {
   MqlRates mrate[];
   ArraySetAsSeries(mrate,true);
   if(CopyRates(_Symbol,_Period,0,2,mrate) < 0)
     {
      Alert("Error getting the latest price quote - error:",GetLastError(),"!");
      return;     
     }       
   double previousHigh = mrate[1].high;
   double previousLow = mrate[1].low;
   double CurrentBid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits); 
   double CurrentAsk = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   if(type == ORDER_TYPE_BUY)
     {
      if((CurrentAsk > previousHigh) && (CurrentAsk > TideBar[1].low))
        {
         if(OpenPosition(type))
            {
            TripleScreen = true;
            ForceActivated = true;
            }
        }
     }
   if(type == ORDER_TYPE_SELL)
     {
      if((CurrentBid < previousLow) && (CurrentBid < TideBar[1].high))
        {
         if(OpenPosition(type))
            {
            TripleScreen = true;
            ForceActivated = true;
            }
        }
     }  
  }
  
bool OpenPosition(ENUM_ORDER_TYPE type)
  {
   trade.SetExpertMagicNumber(EA_Magic);
   trade.SetDeviationInPoints(15);
   trade.SetTypeFilling(ORDER_FILLING_IOC);
   trade.SetAsyncMode(false);
   MqlTick latest_price;
   if(!SymbolInfoTick(_Symbol,latest_price))
     {
      Alert("Error getting the latest price quote - error:",GetLastError(),"!");
      return(false);      
     }
   if(type == ORDER_TYPE_BUY && !Sell_opened)
     {
      if(Buy_opened)
        {
         if(latest_price.ask < ((previousUsedPrice) + (2 * ATR[0]))) //Cannot trade unless 2% stop is covered
           {
            return(false);
           }
        }
      bool results = trade.Buy(lotUnits,_Symbol,latest_price.ask,0,0,NULL);
      uint retcode = trade.ResultRetcode();
      if(results && (retcode == 10009 || retcode == 10008))
        {
         Alert("Buy order for ", _Symbol," has been placed with Ticket #: ",trade.ResultOrder());
         previousUsedPrice = NormalizeDouble(trade.ResultPrice(),_Digits);
         Buy_opened = true;
         PositionThisBar = true;
         SetStops();
         return(true);
        }
      else
        {
			Alert("Buy order for ", _Symbol," failed - error: ",GetLastError()," with trade error ",retcode," - ",trade.ResultRetcodeDescription(),". Price used ",latest_price.ask,". Volume used ",lotUnits);
			ResetLastError();
			return(false);
        }  
     }
   if(type == ORDER_TYPE_SELL && !Buy_opened)
     {
      if(Sell_opened)
        {
         if(latest_price.bid > (previousUsedPrice - (2 * ATR[0]))) 
           {
            return(false);
           }
        }
      bool results = trade.Sell(lotUnits,_Symbol,latest_price.bid,0,0,NULL);
      uint retcode = trade.ResultRetcode();
      if(results && (retcode == 10009 || retcode == 10008))
        {
         Alert("Sell order for ", _Symbol," has been placed with Ticket #: ",trade.ResultOrder());
         previousUsedPrice = NormalizeDouble(trade.ResultPrice(),_Digits);
         Sell_opened = true;
         PositionThisBar = true;
         SetStops();
         return(true);
        }
      else
        {
			Alert("Sell order for ", _Symbol," failed - error: ",GetLastError()," with trade error ",retcode," - ",trade.ResultRetcodeDescription(),". Price used: ",latest_price.bid,". Volume used: ",lotUnits);
			ResetLastError();
			return(false);
        }  
     }
   else
     {
      return(false);
     }       
  }
  
void SetStops()
  {
   if(Buy_opened)
     {
      ProtectiveStop = NormalizeDouble(previousUsedPrice - (2 * ATR[0]),_Digits);
      ProfitExit = NormalizeDouble(previousUsedPrice + (6 * ATR[0]),_Digits);
     }
   if(Sell_opened)
     {
      ProtectiveStop = NormalizeDouble(previousUsedPrice + (2 * ATR[0]),_Digits);
      ProfitExit = NormalizeDouble(previousUsedPrice - (6 * ATR[0]),_Digits);
     }    
  }
  
void AdjustStops()
  {
   MqlRates mrate[];
   ArraySetAsSeries(mrate,true);
   if(CopyRates(_Symbol,_Period,0,2,mrate) < 0)
     {
      Alert("Error getting the latest price quote - error:",GetLastError(),"!");
      return;     
     }
   double previousHigh = mrate[1].high;
   double previousLow = mrate[1].low;
   if(Buy_opened)
     {
      ProtectiveStop = previousLow;
     }
   if(Sell_opened)
     {
      ProtectiveStop = previousHigh;
     }  
  }  
  
void CheckStops()
  {
   double CurrentBid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits); 
   double CurrentAsk = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double PriceCurrent = NormalizeDouble((CurrentAsk + CurrentBid) / 2,_Digits);
   if(Buy_opened)
     {
      if(PriceCurrent < ProtectiveStop)
        {
         ClosePosition();
        }
      if(ImpulseSystem)
        {
         if(CurrentBid > ProfitExit)
           {
            ClosePosition();
           }
        }  
     }
   else if(Sell_opened)
          {
           if(PriceCurrent > ProtectiveStop)
             {
              ClosePosition();
             }
           if(ImpulseSystem)
             {
              if(CurrentAsk < ProfitExit)
                {
                 ClosePosition();
                }
             }  
          }         
  }
  
void ClosePosition()
  {
   trade.SetAsyncMode(true);
   trade.PositionClose(_Symbol,-1);
   Alert("Close code: ",trade.ResultRetcode()," Protected balance is $",saveBank," Usable Balance is $",usefulBalance);
   TripleScreen = false;
   ImpulseSystem = false;
   ForceActivated = false;
   Buy_opened = false;
   Sell_opened = false;
  }      
//+------------------------------------------------------------------+
*/