# 获取A股日线与后复权因子

###目的：

* 获取沪深所有A股日线（日期、开高低收、量额）和后复权因子

###代码说明

* initStockDay.py 分割A股列表为20个子列表；输入nameList.txt; 输出20个dayList.txt，建立DayList、StockDay、StockDayError、TickLists

* getStockDay.py 获取A股日线与复权因子，生成TickList；输入dayList（股票子列表）与时间；输出**日线、复权数据** 和 **TickLists**

* startGetStockDay.sh 同时运行20个进程

###参考链接：

* 日线数据：<http://money.finance.sina.com.cn/corp/go.php/vMS_FuQuanMarketHistory/stockid/600000.phtml?year=2012&jidu=4>

