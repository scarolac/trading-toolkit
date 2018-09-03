//+------------------------------------------------------------------+
//|                                                SwingAndTrend.mqh |
//|                                                    Chris Scarola |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Chris Scarola"
#property link      "https://www.mql5.com"
//+------------------------------------------------------------------+
//| SwingPoint Class                                                 |
//+------------------------------------------------------------------+
enum ENUM_SWING_TYPE
{
	SWING_HIGH,
	SWING_LOW
};
class CSwingPoint
{
	private:
		double 			   	price;
		long 			    volume;
		datetime 		   	time;
		ENUM_SWING_TYPE		type;
	public:
		void				Price(double p){price = p;}
		double				Price() {return price;}
		void				Volume(long v){volume = v;}
		long				Volume(){return volume;}
		void				Time(datetime t){time = t;}
		datetime			Time(){return time;}
		void				Type(ENUM_SWING_TYPE s){type = s;}
		ENUM_SWING_TYPE   	Type(){return type;}
		void              	Draw();
		void              	DeleteArrow();
		CSwingPoint()
			:price(0), volume(0), time(0), type(NULL){}
		CSwingPoint(double p, long v, datetime t, ENUM_SWING_TYPE s)
			:price(p), volume(v), time(t), type(s){}
		~CSwingPoint(){}
};
void CSwingPoint::Draw()
{
	string objName = TimeToString(time,TIME_DATE) + " " + TimeToString(time,TIME_MINUTES);
	double buffer;
	if(_Digits == 5) buffer = 0.0005;
	else buffer = 0.05;
	if(price == 0.0) return;
	if(type == SWING_HIGH)
	{
		ObjectCreate(0,"SH " + objName,OBJ_ARROW_UP,0,time,price + buffer);
		ObjectSetInteger(0,"SH " + objName,OBJPROP_COLOR,clrLimeGreen);
		ObjectSetInteger(0,"SH " + objName,OBJPROP_ANCHOR,ANCHOR_BOTTOM);
	}
	else if(type == SWING_LOW)
	{
		ObjectCreate(0,"SL " + objName,OBJ_ARROW_DOWN,0,time,price - buffer);
		ObjectSetInteger(0,"SL " + objName,OBJPROP_COLOR,clrMediumSlateBlue);
	}	
}
//+------------------------------------------------------------------+
//| Trend Class                                                      |
//+------------------------------------------------------------------+
enum TREND_DIRECTION
{
	UPTREND,
	DOWNTREND,
	SIDEWAYS_TREND
};
enum TREND_STRENGTH
{
	CONFIRMED,
	SUSPECT
};
class CTrend
{
	private:
		TREND_STRENGTH 		strength;
		TREND_DIRECTION 	direction;
	public:
		void				Strength(TREND_STRENGTH s){strength = s;}
		TREND_STRENGTH		Strength(){return strength;}
		void				Direction(TREND_DIRECTION d){direction = d;}
		TREND_DIRECTION		Direction(){return direction;}
		void              	CheckUpTrend(double price, long vol, double recentPrice, long recentVol);
		void              	CheckDownTrend(double price, long vol, double recentPrice, long recentVol);
		CTrend()
			:strength(CONFIRMED), direction(SIDEWAYS_TREND){}
		CTrend(TREND_STRENGTH s, TREND_DIRECTION d)
			:strength(s), direction(d){}
		~CTrend(){}
};
void CTrend::CheckUpTrend(double price, long vol, double recentPrice, long recentVol)
{
	if(recentPrice == 0.0000) return;
	if(price > recentPrice)
	{
		if(direction == SIDEWAYS_TREND) direction = UPTREND;
		if(direction == DOWNTREND) direction = SIDEWAYS_TREND;
		if(vol > recentVol)
		{
			strength = CONFIRMED;
		}
		else strength = SUSPECT;
	}
}
void CTrend::CheckDownTrend(double price, long vol, double recentPrice, long recentVol)
{
	if(recentPrice == 0.0000) return;
	if(price < recentPrice)
	{
		if(direction == UPTREND) direction = SIDEWAYS_TREND;
		if(direction == SIDEWAYS_TREND) direction = DOWNTREND;
		if(vol > recentVol)
		{
			strength = CONFIRMED;
		}
		else strength = SUSPECT;
	}
}
/*
void CTrend::InitTrend(MqlRates &ratebars[], SwingPoint &sp[])
{
	//find index of the ratebars then go from there, use ArrayBSearch function
	int barcount;
	int spSize = ArraySize(sp);
	ArraySetAsSeries(ratebars, true);	
	
	for(int i = 0; i < spSize; i++))
	{
		if(sp[i+1].Price() == 0.0) return; //returns if the next swingpoint does not exist
		
		//get the number of bars between current and next swingpoint
		//gets time between the two points, divides by the seconds in the period used
		barcount = ((sp[i+1].Time() - sp[i].Time()) / PeriodSeconds(_Period)); 		
		//copy the ratebars needed between current and next swingpoint
		if(CopyRates(_Symbol,_Period,sp[i].Time(),sp[i+1].Time(),ratebars))
		{
			Alert("Error getting prices for trend initialization - ",GetLastError());
			return;
		}
		//Search through the rate bars for the time between the current and next swing point
		
		if(sp[i].Type() == SWING_HIGH)
		{
			for(int j = 0; j <= barcount; j++)
			{
				if(ratebars[j].close > sp[i].Price())
				{
					if(ratebars[j].tick_volume > sp[i].Volume())
					{
						
					}
				}
			}
		}
		if(sp[i].Type() == SWING_LOW)		
		{
			for(int k = 0; k <= barcount; k++)
			{
			
			}
		}
	}
}
*/
