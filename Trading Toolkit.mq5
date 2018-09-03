//+------------------------------------------------------------------+
//|                                               TradingToolkit.mq5 |
//|                                                    Chris Scarola |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Chris Scarola"
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <QuadBananaBlast.mqh>

CQuadBananaBlast Toolkit;

input ENUM_TIMEFRAMES Tide_Timeframe = PERIOD_M30; 	//Timeframe for the Third screen
input ENUM_TIMEFRAMES Wave_Timeframe = PERIOD_M5;     //Timeframe for the Second screen
input ENUM_TIMEFRAMES Ripple_Timeframe = PERIOD_M1;   //Timeframe for the First screen
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create application dialog
   if(!Toolkit.Create(0,"Trading Toolkit",0,0,0,280,200,Tide_Timeframe,Wave_Timeframe,Ripple_Timeframe))
	{
		Alert("Error = ",GetLastError());
		ResetLastError();
		return(INIT_FAILED);
	}
   if(!Toolkit.Run())
		return(INIT_FAILED);   
//---
	return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Toolkit.Destroy(reason);   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   Toolkit.RefreshTick();
//--- If a new bar is showing, run the new bar section
   if(isNewBar()) OnNewBar();   
  }
void OnNewBar()
  {
//--- 
   Toolkit.RefreshBar();   
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   Toolkit.ChartEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
//| Expert Trade Transaction function                                |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result)
  {
    if(trans.type == TRADE_TRANSACTION_DEAL_ADD)
    {
        if(trans.deal_type == DEAL_TYPE_BUY && trans.deal > 0)
            Toolkit.OnTransaction(DEAL_TYPE_BUY);
        else if(trans.deal_type == DEAL_TYPE_SELL && trans.deal > 0)
            Toolkit.OnTransaction(DEAL_TYPE_SELL);
    }         
  }    
bool isNewBar()
{
	static datetime Old_Time;
	datetime New_Time[1];
	
	if((CopyTime(_Symbol,Ripple_Timeframe,0,1,New_Time)) > 0)
	{
		if(Old_Time == New_Time[0]) return false;
		Old_Time = New_Time[0];
		return true;
	}
	else
	{
		Alert("Error in copying historical times data, error =",GetLastError());
		ResetLastError();
		return false;
	}
}
//+------------------------------------------------------------------+
